use std::sync::Arc;

use axum::{
    Json,
    extract::{Path, Query, State},
    http::StatusCode,
    response::IntoResponse,
};
use axum_extra::extract::CookieJar;
use chrono::Local;
use serde_json::json;
use uuid::Uuid;

use crate::{
    AppState,
    error::Error,
    model::{
        ToResponse,
        tag::{TagModel, TagResponseModel},
    },
    schema::{
        FilterOptions,
        tag::{CreateTagSchema, QueryTagSchema, UpdateTagSchema},
    },
    util::{AddToQuery, PostgresCmp, SQLQueryBuilder, extract_user_id},
};

pub async fn create_tag_handler(
    State(data): State<Arc<AppState>>,
    jar: CookieJar,
    Json(body): Json<CreateTagSchema>,
) -> Result<impl IntoResponse, (StatusCode, Json<serde_json::Value>)> {
    // Get user id
    let user_id = extract_user_id(&jar).map_err(|e| e.err_map())?;

    // Get database connection and start transaction
    let mut conn = data.get_conn().await.map_err(|e| e.err_map())?;
    let transaction = conn
        .transaction()
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Create tag
    let mut query_builder = SQLQueryBuilder::new(TagModel::TABLE);
    query_builder.add_column(TagModel::USER_ID, &user_id);
    body.add_to_query(&mut query_builder);
    query_builder.set_return_all();

    let (statement, params) = query_builder.build_insert();

    let row = transaction
        .query_one(&statement, &params)
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Commit transaction
    transaction
        .commit()
        .await
        .map_err(|e| Error::from(e).err_map())?;

    let tag = TagModel::from(row);

    Ok((
        StatusCode::CREATED,
        Json(json!({
            "status": "ok",
            "data": {
                "tag": tag.to_response(),
            },
        })),
    ))
}

pub async fn retrieve_tag_handler(
    State(data): State<Arc<AppState>>,
    jar: CookieJar,
    Path(id): Path<Uuid>,
) -> Result<impl IntoResponse, (StatusCode, Json<serde_json::Value>)> {
    // Get user id
    let user_id = extract_user_id(&jar).map_err(|e| e.err_map())?;

    // Get database connection
    let conn = data.get_conn().await.map_err(|e| e.err_map())?;

    // Retrieve tag
    let mut query_builder = SQLQueryBuilder::new(TagModel::TABLE);
    query_builder.add_condition(TagModel::USER_ID, PostgresCmp::Equal, &user_id);
    query_builder.add_condition(TagModel::ID, PostgresCmp::Equal, &id);
    query_builder.set_return_all();

    let (statement, params) = query_builder.build_select();

    let row_opt = conn
        .query_opt(&statement, &params)
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Get retrieved tag
    let tag = match row_opt {
        Some(row) => TagModel::from(row),
        None => {
            let json_message = json!({
                "status": "unsuccessful",
                "message": format!("tag not found"),
            });

            return Err((StatusCode::NOT_FOUND, Json(json_message)));
        }
    };

    Ok(Json(json!({
        "status": "success",
        "data": json!({
            "tag": tag.to_response(),
        }),
    })))
}

pub async fn update_tag_handler(
    State(data): State<Arc<AppState>>,
    jar: CookieJar,
    Path(id): Path<Uuid>,
    Json(body): Json<UpdateTagSchema>,
) -> Result<impl IntoResponse, (StatusCode, Json<serde_json::Value>)> {
    // Get user id
    let user_id = extract_user_id(&jar).map_err(|e| e.err_map())?;

    // Get database connection and start transaction
    let mut conn = data.get_conn().await.map_err(|e| e.err_map())?;
    let transaction = conn
        .transaction()
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Update tag
    let timestamp = Local::now();
    let mut query_builder = SQLQueryBuilder::new(TagModel::TABLE);
    query_builder.add_column(TagModel::UPDATED, &timestamp);
    body.add_to_query(&mut query_builder);
    query_builder.add_condition(TagModel::USER_ID, PostgresCmp::Equal, &user_id);
    query_builder.add_condition(TagModel::ID, PostgresCmp::Equal, &id);
    query_builder.set_return_all();

    let (statement, params) = query_builder.build_update();

    let row_opt = transaction
        .query_opt(&statement, &params)
        .await
        .map_err(|e| Error::from(e).err_map())?;

    if row_opt.is_none() {
        let json_message = json!({
            "status": "unsuccessful",
            "message": format!("tag not found"),
        });

        return Err((StatusCode::NOT_FOUND, Json(json_message)));
    }

    // Commit transaction
    transaction
        .commit()
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Get updated tag
    let tag = TagModel::from(row_opt.unwrap());

    Ok(Json(json!({
        "status": "success",
        "data": json!({
            "tag": tag.to_response(),
        }),
    })))
}

pub async fn delete_tag_handler(
    State(data): State<Arc<AppState>>,
    jar: CookieJar,
    Path(id): Path<Uuid>,
) -> Result<impl IntoResponse, (StatusCode, Json<serde_json::Value>)> {
    // Get user id
    let user_id = extract_user_id(&jar).map_err(|e| e.err_map())?;

    // Get database connection and start transaction
    let mut conn = data.get_conn().await.map_err(|e| e.err_map())?;
    let transaction = conn
        .transaction()
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Delete tag
    let mut query_builder = SQLQueryBuilder::new(TagModel::TABLE);
    query_builder.add_condition(TagModel::USER_ID, PostgresCmp::Equal, &user_id);
    query_builder.add_condition(TagModel::ID, PostgresCmp::Equal, &id);
    query_builder.set_return(vec![TagModel::ID]);

    let (statement, params) = query_builder.build_delete();

    let row_opt = transaction
        .query_opt(&statement, &params)
        .await
        .map_err(|e| Error::from(e).err_map())?;

    // Commit transaction
    transaction
        .commit()
        .await
        .map_err(|e| Error::from(e).err_map())?;

    if row_opt.is_none() {
        let json_message = json!({
            "status": "unsuccessful",
            "message": format!("tag not found"),
        });

        return Err((StatusCode::NOT_FOUND, Json(json_message)));
    }

    Ok(StatusCode::NO_CONTENT)
}

pub async fn query_tag_handler(
    State(data): State<Arc<AppState>>,
    jar: CookieJar,
    Query(opts): Query<FilterOptions>,
    Json(body): Json<QueryTagSchema>,
) -> Result<impl IntoResponse, (StatusCode, Json<serde_json::Value>)> {
    // Get user id
    let user_id = extract_user_id(&jar).map_err(|e| e.err_map())?;

    // Get database connection
    let conn = data.get_conn().await.map_err(|e| e.err_map())?;

    // Get pagination info
    let page = opts.page.unwrap_or(1);
    let limit = opts.limit.unwrap_or(25);
    let offset = (page - 1) * limit;

    // Query tags
    let mut query_builder = SQLQueryBuilder::new(TagModel::TABLE);
    body.add_to_query(&mut query_builder);
    query_builder.add_condition(TagModel::USER_ID, PostgresCmp::Equal, &user_id);
    query_builder.set_limit(limit);
    query_builder.set_offset(offset);

    let (statement, params) = query_builder.build_select();

    let rows = conn
        .query(&statement, &params)
        .await
        .map_err(|e| Error::from(e).err_map())?;

    let tags: Vec<TagModel> = rows.iter().map(|r| TagModel::from(r.to_owned())).collect();

    let tag_responses: Vec<TagResponseModel> = tags.iter().map(|a| a.to_response()).collect();

    Ok(Json(json!({
        "status": "ok",
        "data": json!({
            "count": tag_responses.len(),
            "tags": tag_responses,
        }),
    })))
}

// TEST: handler tests?
