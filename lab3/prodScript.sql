-- CREATE TABLE MyTable(
--     id NUMBER,
--     val VARCHAR2(10)
-- );

-- CREATE TABLE MainTable(
--     id NUMBER,
--     name VARCHAR(2)
-- );

-- CREATE PROCEDURE MainProc (num IN NUMBER) IS
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE('Main Proc ' ||num|| ' !');
-- END;

-- DROP PROCEDURE MainProc;

-- CREATE PROCEDURE DoubleProc (num IN VARCHAR2) IS
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE('Double Proc ' ||num|| ' !');
-- END;

-- CREATE FUNCTION MainFunc (num IN NUMBER) RETURN VARCHAR2 IS
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE(num);
--     RETURN 'main func';
-- END;

-- DROP FUNCTION MainFunc;

-- CREATE INDEX mainTableName ON MainTable (id);

CREATE TABLE ProdTable(
    id NUMBER,
    prod VARCHAR(2)
);