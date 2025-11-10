
database tables- 


mysql> use form_builder;
Database changed
mysql> show tables;
+------------------------+
| Tables_in_form_builder |
+------------------------+
| answers                |
| forms                  |
| options                |
| questions              |
| responses              |
+------------------------+
5 rows in set (0.00 sec)

mysql> desc answers;
+-------------+------+------+-----+---------+----------------+
| Field       | Type | Null | Key | Default | Extra          |
+-------------+------+------+-----+---------+----------------+
| answer_id   | int  | NO   | PRI | NULL    | auto_increment |
| response_id | int  | YES  | MUL | NULL    |                |
| question_id | int  | YES  | MUL | NULL    |                |
| answer_text | text | YES  |     | NULL    |                |
+-------------+------+------+-----+---------+----------------+
4 rows in set (0.01 sec)

mysql> desc forms;
+-------------+--------------+------+-----+-------------------+-------------------+
| Field       | Type         | Null | Key | Default           | Extra             |
+-------------+--------------+------+-----+-------------------+-------------------+
| form_id     | int          | NO   | PRI | NULL              | auto_increment    |
| title       | varchar(255) | NO   |     | NULL              |                   |
| description | text         | YES  |     | NULL              |                   |
| created_by  | varchar(100) | YES  |     | NULL              |                   |
| created_at  | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
+-------------+--------------+------+-----+-------------------+-------------------+
5 rows in set (0.01 sec)

mysql> desc options;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| option_id   | int          | NO   | PRI | NULL    | auto_increment |
| question_id | int          | YES  | MUL | NULL    |                |
| option_text | varchar(255) | NO   |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+
3 rows in set (0.00 sec)

mysql> desc questions;
+---------------+-------------+------+-----+---------+----------------+
| Field         | Type        | Null | Key | Default | Extra          |
+---------------+-------------+------+-----+---------+----------------+
| question_id   | int         | NO   | PRI | NULL    | auto_increment |
| form_id       | int         | YES  | MUL | NULL    |                |
| question_text | text        | NO   |     | NULL    |                |
| question_type | varchar(50) | YES  |     | NULL    |                |
+---------------+-------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> desc responses;
+--------------+-----------+------+-----+-------------------+-------------------+
| Field        | Type      | Null | Key | Default           | Extra             |
+--------------+-----------+------+-----+-------------------+-------------------+
| response_id  | int       | NO   | PRI | NULL              | auto_increment    |
| form_id      | int       | YES  | MUL | NULL              |                   |
| submitted_at | timestamp | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
+--------------+-----------+------+-----+-------------------+-------------------+
3 rows in set (0.00 sec)

mysql> 

