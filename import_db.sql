CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id),
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question INTEGER NOT NULL,
  parent_reply INTEGER,
  body VARCHAR(255) NOT NULL,


  FOREIGN KEY (subject_question) REFERENCES questions(id),
  FOREIGN KEY (parent_reply) REFERENCES replies(id),
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question INTEGER NOT NULL,
  user INTEGER NOT NULL,

  FOREIGN KEY (question) REFERENCES questions(id),
  FOREIGN KEY (user) REFERENCES users(id),
);

INSERT INTO
  users (fname, )
-- In addition to creating tables, we can seed our database with some
-- -- starting data.
-- INSERT INTO
--   departments (name)
-- VALUES
--   ('mathematics'), ('physics');
--
-- INSERT INTO
--   professors (first_name, last_name, department_id)
-- VALUES
--   ('Albert', 'Einstein', (SELECT id FROM departments WHERE name = 'physics')),
--   ('Kurt', 'Godel', (SELECT id FROM departments WHERE name = 'mathematics'));
