use axum::{Json, http::StatusCode};
use serde_json::json;

// TODO: use thiserror

#[derive(Debug)]
pub enum Error {
    DatabasePool(deadpool_postgres::PoolError),
    Database(tokio_postgres::Error),
    InvalidRequest(String),
    Internal,
    Generic,
}

impl Error {
    pub fn err_map(&self) -> (StatusCode, Json<serde_json::Value>) {
        match self {
            Error::DatabasePool(pool_error) => {
                eprintln!("Database Pool Error: {:#}", pool_error);

                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    Json(json!({
                        "status": "error",
                        "message": "database connection error",
                    })),
                )
            }
            Error::Database(error) => {
                eprintln!("Database Error: {:#}", error);

                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    Json(json!({
                        "status": "error",
                        "message": "database query error"
                    })),
                )
            }
            Error::InvalidRequest(s) => {
                eprintln!("Error: {:#}", s);

                (
                    StatusCode::BAD_REQUEST,
                    Json(json!({
                        "status": "error",
                        "message": "error in the request"
                    })),
                )
            }
            Error::Internal => {
                eprintln!("Internal Error");

                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    Json(json!({
                        "status": "error",
                        "message": "internal error occured",
                    })),
                )
            }
            Error::Generic => {
                eprintln!("Generic Error");

                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    Json(json!({
                        "status": "error",
                        "message": "generic error occured"
                    })),
                )
            }
        }
    }
}

impl From<deadpool_postgres::PoolError> for Error {
    fn from(value: deadpool_postgres::PoolError) -> Self {
        Self::DatabasePool(value)
    }
}

impl From<tokio_postgres::Error> for Error {
    fn from(value: tokio_postgres::Error) -> Self {
        Self::Database(value)
    }
}
