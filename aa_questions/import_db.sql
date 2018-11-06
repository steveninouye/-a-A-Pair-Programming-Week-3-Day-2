PRAGMA foreign_keys = ON;

DROP TABLE if exists question_likes;
DROP TABLE if exists question_follows;
DROP TABLE if exists replies;
DROP TABLE if exists questions;
DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(150) NOT NULL,
  lname VARCHAR(150) NOT NULL
);

DROP TABLE if exists questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE if exists question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  
  PRIMARY KEY (user_id, question_id)
);

DROP TABLE if exists replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  parent_id INTEGER,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE if exists question_likes;

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  
  PRIMARY KEY (user_id, question_id)
);

-----------------------
-- INSERT INTO TABLES SECTION

INSERT INTO 
  users (fname, lname)
VALUES
  ('Bao', 'Tran'),
  ('Steven', 'Inouye'),
  ('Sai', 'Patt'),
  ('Filipp', 'Kramer'),
  ('Ryan', 'Mapa');
  
INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Who is this?', 'Who is my T.A.?', (SELECT id FROM users WHERE fname = 'Bao' AND lname = 'Tran')),
  ('What are the answers to the test?', 'I''ll pay $100 for the answers tonight.  Thank you!', (SELECT id FROM users WHERE fname = 'Steven' AND lname = 'Inouye'));

INSERT INTO
  replies (body, question_id, user_id)
VALUES
  ('Banana', (SELECT id FROM questions WHERE title = 'What are the answers to the test?'), (SELECT id FROM users WHERE fname = 'Bao' AND lname = 'Tran')),
  ('Apple', (SELECT id FROM questions WHERE title = 'Who is this?'), (SELECT id FROM users WHERE fname = 'Sai' AND lname = 'Patt'));

INSERT INTO 
  question_follows(user_id, question_id)
VALUES 
  ((SELECT id FROM users WHERE fname = 'Bao' AND lname = 'Tran'), (SELECT id FROM questions WHERE title = 'Who is this?')),
  (3, 1);

INSERT INTO 
  question_likes(user_id, question_id)
VALUES 
  (3, 1);

  
  