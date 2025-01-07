-- Reset Tables
-- Clear tables
TRUNCATE
	todo_auth.users,
	todo_data.tasks,
	todo_data.projects,
	todo_data.areas,
	todo_data.tags
CASCADE;


-- User: Testing Users
INSERT INTO todo_auth.users
(
	username
)
VALUES
(
    'Test User 1'
),
(
    'Test User 2'
),
(
    'Test User 3'
);


-- Task 0: No Title Test
INSERT INTO todo_data.tasks
(
	task_notes,

	user_id
)
VALUES
(
	'No Title',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Task A: Date Tests
INSERT INTO todo_data.tasks
(
    task_title,
    task_notes,

    start_date,
    start_time,
    deadline,

    user_id
)
VALUES
(
    'Task A0',
    'No start date, No start time, No deadline',

    NULL,
    NULL,
    NULL,

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
    'Task A1',
    'Start date, No start time, No deadline',

    '2026-01-01',
    NULL,
    NULL,

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
    'Task A2',
    'Start date, Start time, No deadline',

    '2026-01-01',
    '12:00:00',
    NULL,

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
    'Task A3',
    'No start date, No start time, Deadline',

    NULL,
    NULL,
    '2026-02-01',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
    'Task A4',
    'Start date, No start time, Deadline',

    '2026-01-01',
    NULL,
    '2026-02-01',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
    'Task A5',
    'Start date, Start time, Deadline',

    '2026-01-01',
    '12:00:00',
    '2026-02-01',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Task B: Complete, log, and trash test
INSERT INTO todo_data.tasks
(
	task_title,
	task_notes,

	user_id,
	completed_on,
	logged_on,
	trashed_on
)
VALUES
(
    'Task B0',
    'No Completed, No Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
	NULL,
	NULL
),
(
    'Task B1',
    'No Completed, No Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
    NULL,
    '2025-01-03'
),
(
    'Task B2',
    'No Completed, Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
    '2025-01-02',
    NULL
),
(
    'Task B3',
    'No Completed, Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
    '2025-01-02',
    '2025-01-03'
),
(
    'Task B4',
    'Completed, No Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
	NULL,
	NULL
),
(
    'Task B5',
    'Completed, No Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
	NULL,
    '2025-01-03'
),
(
    'Task B6',
    'Completed, Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
    '2025-01-02',
    NULL
),
(
    'Task B7',
    'Completed, Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
    '2025-01-02',
    '2025-01-03'
);


-- Project 0: No Title Test
INSERT INTO todo_data.projects
(
	project_notes,

	user_id
)
VALUES
(
	'No Title',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Project A: Date Test
INSERT INTO todo_data.projects
(
	project_title,
    project_notes,

    start_date,
    start_time,
    deadline,

    user_id
)
VALUES
(
	'Project A0',
	'No start date, No start time, No deadline',

	NULL,
	NULL,
	NULL,

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Project A1',
	'Start date, No start time, No deadline',

	'2026-01-01',
	NULL,
	NULL,

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Project A2',
	'Start date, Start time, No deadline',

	'2026-01-01',
	'12:00:00',
	NULL,

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Project A3',
	'No start date, No start time, Deadline',

	NULL,
	NULL,
	'2026-02-01',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Project A4',
	'Start date, No start time, Deadline',

	'2026-01-01',
	NULL,
	'2026-02-01',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Project A5',
	'Start date, Start time, Deadline',

	'2026-01-01',
	'12:00:00',
	'2026-02-01',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Project B: Complete, log, and trash test
INSERT INTO todo_data.projects
(
	project_title,
	project_notes,

	user_id,
	completed_on,
	logged_on,
	trashed_on
)
VALUES
(
    'Project B0',
    'No Completed, No Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
	NULL,
	NULL
),
(
    'Project B1',
    'No Completed, No Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
    NULL,
    '2025-01-03'
),
(
    'Project B2',
    'No Completed, Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
    '2025-01-02',
    NULL
),
(
    'Project B3',
    'No Completed, Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    NULL,
    '2025-01-02',
    '2025-01-03'
),
(
    'Project B4',
    'Completed, No Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
	NULL,
	NULL
),
(
    'Project B5',
    'Completed, No Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
	NULL,
    '2025-01-03'
),
(
    'Project B6',
    'Completed, Logged, No Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
    '2025-01-02',
    NULL
),
(
    'Project B7',
    'Completed, Logged, Trashed',

    (SELECT user_id FROM todo_auth.users WHERE username='Test User 1'),
    '2025-01-01',
    '2025-01-02',
    '2025-01-03'
);


-- Project C[Task C]: No Area
INSERT INTO todo_data.projects
(
	project_title,
	project_notes,

	user_id
)
VALUES
(
	'Project C0',
	'No Area',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);

INSERT INTO todo_data.tasks
(
	task_title,
	task_notes,

	project_id,

	user_id
)
VALUES
(
	'Task C0',
	'In Project C0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project C0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task C1',
	'In Project C0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project C0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task C2',
	'In Project C0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project C0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task C3',
	'In Project C0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project C0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task C4',
	'In Project C0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project C0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Area 0: No Name
INSERT INTO todo_data.areas
(
	user_id
)
VALUES
(
	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')	
);


-- Area D: Project that contains tasks
INSERT INTO todo_data.areas
(
	area_name,

	user_id
)
VALUES
(
	'Area D',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);

INSERT INTO todo_data.projects
(
	project_title,
	project_notes,

	area_id,

	user_id
)
VALUES
(
	'Project D0',
	'In Area D',

	(SELECT area_id FROM todo_data.areas WHERE area_name='Area D'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')	
);

INSERT INTO todo_data.tasks
(
	task_title,
	task_notes,

	project_id,

	user_id
)
VALUES
(
	'Task D0',
	'In Project D0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project D0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task D1',
	'In Project D0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project D0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task D2',
	'In Project D0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project D0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task D3',
	'In Project D0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project D0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task D4',
	'In Project D0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project D0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Area E: Contains both tasks and projects
INSERT INTO todo_data.areas
(
	area_name,

	user_id
)
VALUES
(
	'Area E',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);

INSERT INTO todo_data.tasks
(
	task_title,
	task_notes,

	area_id,

	user_id
)
VALUES
(
	'Task E0',
	'In Area E',

	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task E1',
	'In Area E',

	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task E2',
	'In Area E',

	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task E3',
	'In Area E',

	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task E4',
	'In Area E',

	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);

INSERT INTO todo_data.projects
(
	project_title,
	project_notes,

	area_id,

	user_id
)
VALUES
(	
	'Project E0',
	'In Area E',
	
	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(	
	'Project E1',
	'In Area E',
	
	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(	
	'Project E2',
	'In Area E',
	
	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(	
	'Project E3',
	'In Area E',
	
	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(	
	'Project E4',
	'In Area E',
	
	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Project F: In Area E and contains tasks
INSERT INTO todo_data.projects
(
	project_title,
	project_notes,

	area_id,

	user_id
)
VALUES
(	
	'Project F0',
	'In Area E',
	
	(SELECT area_id FROM todo_data.areas WHERE area_name='Area E'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);

INSERT INTO todo_data.tasks
(
	task_title,
	task_notes,

	project_id,

	user_id
)
VALUES
(
	'Task F0',
	'In Project F0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project F0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task F1',
	'In Project F0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project F0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task F2',
	'In Project F0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project F0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task F3',
	'In Project F0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project F0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Task F4',
	'In Project F0',

	(SELECT project_id FROM todo_data.projects WHERE project_title='Project F0'),

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);

-- Tag: Add various tags
INSERT INTO todo_data.tags
(
	tag_label,
	tag_category,

	user_id
)
VALUES
(
	'Urgent',
	NULL,

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Important',
	NULL,

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Low',
	'Priority',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Mid',
	'Priority',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'High',
	'Priority',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Backlog',
	'Scrum',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'To-do',
	'Scrum',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'In-progress',
	'Scrum',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Done',
	'Scrum',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Class 1',
	'School',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Class 2',
	'School',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Class 3',
	'School',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Class 4',
	'School',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
),
(
	'Class 5',
	'School',

	(SELECT user_id FROM todo_auth.users WHERE username='Test User 1')
);


-- Task G: Priority



-- Task H: School



-- Task I: Scrum



-- Project G: Priority



-- Project H: School

