
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Harry', 'Miller'), ('Dave', 'Hassan');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Wat?', 'How do I even?', (SELECT id FROM users WHERE fname = 'Harry'));

INSERT INTO
  replies (subject_question_id, parent_reply_id, body, author_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Wat?'), NULL, 'Wat??',
    (SELECT author_id FROM questions WHERE title = 'Wat?'));

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Wat?'),
  (SELECT id FROM users WHERE lname = 'Hassan'));
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
