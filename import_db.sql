CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL,


  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  liker_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (liker_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users(fname, lname)
VALUES
  ('Kiran', 'Surdhar'), ('Grace', 'Do'), ('Tim', 'Kutnick');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Programming', 'Why should I learn how to program?', (SELECT id FROM users WHERE fname = 'Kiran')),
  ('Lunch', 'How long is our lunch break?', (SELECT id FROM users WHERE lname = 'Do'));

INSERT INTO
  question_followers(question_id, follower_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Lunch'), (SELECT id FROM users WHERE fname = 'Kiran')),
  ((SELECT id FROM questions WHERE title = 'Programming'), (SELECT id FROM users WHERE lname = 'Do'));

INSERT INTO
  replies(subject_question_id, parent_reply_id, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Lunch'), NULL, (SELECT id FROM users WHERE lname = 'Surdhar'), "1 hour");

INSERT INTO
  question_likes(liker_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Kutnick'), (SELECT id FROM questions WHERE title = 'Lunch')),
  ((SELECT id FROM users WHERE lname = 'Surdhar'), (SELECT id FROM questions WHERE title = 'Programming'));

INSERT INTO
  replies(subject_question_id, parent_reply_id, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Lunch'), (SELECT id FROM replies WHERE parent_reply_id IS NULL), (SELECT id FROM users WHERE lname = 'Kutnick'), "1 minute");
