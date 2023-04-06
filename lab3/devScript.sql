-- CREATE TABLE MyTable(
--     id NUMBER,
--     val NUMBER
-- );

-- CREATE TABLE YourTable(
--     id NUMBER,
--     num NUMBER
-- );

-- CREATE TABLE MainTable(
--     id NUMBER,
--     name VARCHAR(2)
-- );

-- CREATE TABLE Parent(
--     id NUMBER,
--     name VARCHAR2(10),
--     CONSTRAINT parent_pk PRIMARY KEY (id)
-- );

-- CREATE TABLE Child(
--     id NUMBER,
--     name VARCHAR2(10),
--     parent_id NUMBER,
--     CONSTRAINT fk_parent
--     FOREIGN KEY (parent_id)
--     REFERENCES parent(id)
-- );

-- ALTER TABLE Parent ADD child_id NUMBER;

-- ALTER TABLE Child
-- ADD CONSTRAINT child_pk PRIMARY KEY (id);

-- ALTER TABLE Parent
-- ADD CONSTRAINT fk_child
--   FOREIGN KEY (child_id)
--   REFERENCES child(id);


-- CREATE TABLE Keys(
--     id NUMBER,
--     num_id NUMBER(10)
-- );

-- CREATE TABLE Rooms(
--     id NUMBER,
--     CONSTRAINT room_pk PRIMARY KEY (id)
-- );

-- ALTER TABLE Keys
-- ADD CONSTRAINT fk_room
--   FOREIGN KEY (num_id)
--   REFERENCES rooms(id);


-- CREATE PROCEDURE MainProc (num IN NUMBER) IS
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE('Main Proc ' ||num|| ' !');
-- END;


-- CREATE PROCEDURE DevProc (words IN VARCHAR2) IS
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE('Dev Proc ' ||words|| ' !');
-- END;

-- CREATE FUNCTION MainFunc (num IN NUMBER) RETURN VARCHAR2 IS
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE(num);
--     RETURN 'main func';
-- END;

-- CREATE INDEX mainTableName ON MainTable (name);

CREATE PROCEDURE DoubleProc (num IN NUMBER) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Double Proc ' ||num|| ' !');
END;

--