-- SELECT * FROM all_constraints WHERE owner = 'DEVUSER';


--task 1

-- CREATE TABLE Tables (
--     tableName VARCHAR2(20)
-- );


-- CREATE TABLE OutputTables (
--     tableName VARCHAR2(20)
-- );

-- DELETE FROM Tables;
-- DELETE FROM OutputTables;

-- DECLARE
--     CURSOR devTables IS
--     SELECT * FROM DBA_TABLES
--     WHERE owner = 'DEVUSER';
--     CURSOR prodTables IS
--     SELECT * FROM DBA_TABLES
--     WHERE owner = 'PRODUSER';
--     ch BOOLEAN;
--     c NUMBER;
--     col1 NUMBER;
--     col2 NUMBER;
--     CURSOR differentTables IS
--     SELECT * FROM Tables; 
--     cName VARCHAR2(20);
--     rName VARCHAR2(20); 
-- BEGIN
--     FOR d IN devTables
--     LOOP
--         ch := FALSE;
--         FOR p IN prodTables
--         LOOP
--             IF d.table_name = p.table_name THEN
--                 SELECT COUNT(*) INTO col1 FROM dba_tab_columns
--                 WHERE table_name = d.table_name AND owner = 'DEVUSER';
--                 SELECT COUNT(*) INTO col2 FROM dba_tab_columns
--                 WHERE table_name = p.table_name AND owner = 'PRODUSER';
--                 IF col1 = col2 THEN
--                     c := 0;
--                     FOR typesDev IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = d.table_name AND owner = 'DEVUSER')
--                     LOOP
--                         FOR typesProd IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = p.table_name AND owner = 'PRODUSER')
--                         LOOP
--                             IF typesDev.column_name = typesProd.column_name AND typesDev.data_type = typesProd.data_type THEN
--                                 c := c + 1;
--                             END IF;
--                         END LOOP;
--                     END LOOP;
--                     IF c = col1 THEN
--                             ch := TRUE;
--                     END IF;
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             INSERT INTO Tables VALUES (d.table_name);
--         END IF;
--     END LOOP;
--     FOR t in differentTables
--     LOOP
--         SELECT COUNT(*) INTO col1 FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND table_name = t.tableName AND constraint_type = 'R';
--         SELECT COUNT(*) INTO col2 FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND table_name = t.tableName AND constraint_type = 'P';
--         IF col1 = 1 THEN
--             SELECT r_constraint_name INTO cName FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND table_name = t.tableName AND constraint_type = 'R';
--             SELECT table_name INTO rName FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND constraint_name = cName;
--             DBMS_OUTPUT.PUT_LINE(rName);
--             SELECT COUNT(*) INTO col1 FROM OutputTables WHERE tableName = t.tableName;
--             IF col1 = 0 THEN
--                 INSERT INTO OutputTables VALUES (rname);
--             ELSE
--                 DBMS_OUTPUT.PUT_LINE('loopback connections');
--             END IF;
--             -- DELETE FROM Tables WHERE tableName = rName;
--         END IF;
--         SELECT COUNT(*) INTO col1 FROM OutputTables WHERE tableName = t.tableName;
--         IF col1 = 0 AND col2 = 0 THEN
--             DBMS_OUTPUT.PUT_LINE(t.tableName);
--             INSERT INTO OutputTables VALUES (t.tableName);
--         END IF;
--     END LOOP;   
-- END;


--task2

-- DECLARE
--     CURSOR devProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'DEVUSER' AND object_type = 'PROCEDURE';
--     CURSOR prodProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'PRODUSER' AND object_type = 'PROCEDURE';
--     ch BOOLEAN;
--     c NUMBER;
--     lines NUMBER;
--     line NUMBER := -1;
--     ps VARCHAR2(80);
-- BEGIN
--     FOR d IN devProc 
--     LOOP
--         ch := FALSE;
--         FOR p IN prodProc
--         LOOP
--             IF d.object_name = p.object_name THEN
--                 c := 0;
--                 SELECT COUNT(*) INTO lines FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = d.object_name;
--                 FOR ds IN (SELECT * FROM ALL_SOURCE WHERE owner = 'DEVUSER' AND name = d.object_name)
--                 LOOP
--                     IF ds.line < lines + 1 THEN
--                         SELECT text INTO ps FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = ds.name AND line = ds.line;
--                         IF SUBSTR(ds.text, 1, 4) <> 'END;' THEN
--                             IF ds.text = ps THEN
--                                 c := c + 1;
--                             END IF;
--                         END IF;
--                         IF SUBSTR(ds.text, 1, 4) = 'END;' AND SUBSTR(ps, 1, 4) = 'END;' THEN
--                             line := ds.line;
--                             c := c + 1;
--                             EXIT;
--                         END IF;
--                     END IF;
--                 END LOOP;
--                 IF c = line THEN
--                     ch := TRUE;
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             DBMS_OUTPUT.PUT_LINE(d.object_name);
--         END IF;
--     END LOOP;
-- END;

-- DECLARE
--     CURSOR devProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'DEVUSER' AND object_type = 'FUNCTION';
--     CURSOR prodProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'PRODUSER' AND object_type = 'FUNCTION';
--     ch BOOLEAN;
--     c NUMBER;
--     lines NUMBER;
--     line NUMBER := -1;
--     ps VARCHAR2(80);
-- BEGIN
--     FOR d IN devProc 
--     LOOP
--         ch := FALSE;
--         FOR p IN prodProc
--         LOOP
--             IF d.object_name = p.object_name THEN
--                 c := 0;
--                 SELECT COUNT(*) INTO lines FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = d.object_name;
--                 FOR ds IN (SELECT * FROM ALL_SOURCE WHERE owner = 'DEVUSER' AND name = d.object_name)
--                 LOOP
--                     IF ds.line < lines + 1 THEN
--                         SELECT text INTO ps FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = ds.name AND line = ds.line;
--                         IF SUBSTR(ds.text, 1, 4) <> 'END;' THEN
--                             IF ds.text = ps THEN
--                                 c := c + 1;
--                             END IF;
--                         END IF;
--                         IF SUBSTR(ds.text, 1, 4) = 'END;' AND SUBSTR(ps, 1, 4) = 'END;' THEN
--                             line := ds.line;
--                             c := c + 1;
--                             EXIT;
--                         END IF;
--                     END IF;
--                 END LOOP;
--                 IF c = line THEN
--                     ch := TRUE;
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             DBMS_OUTPUT.PUT_LINE(d.object_name);
--         END IF;
--     END LOOP;
-- END;

-- DECLARE
--     CURSOR devIndexes IS
--     SELECT * FROM ALL_IND_COLUMNS
--     WHERE index_owner = 'DEVUSER';
--     CURSOR prodIndexes IS
--     SELECT * FROM ALL_IND_COLUMNS
--     WHERE index_owner = 'PRODUSER';
--     ch BOOLEAN;
-- BEGIN
--     FOR d IN devIndexes
--     LOOP
--         ch := FALSE;
--         FOR p IN prodIndexes
--         LOOP
--             IF d.index_name = p.index_name THEN
--                 IF d.table_name = p.table_name THEN
--                     IF d.column_name = p.column_name THEN
--                             ch := TRUE;
--                     END IF;
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             IF SUBSTR(d.index_name, 1, 3) <> 'BIN' THEN
--                 DBMS_OUTPUT.PUT_LINE(d.index_name);
--             END IF;
--         END IF;
--     END LOOP;
-- END;

-- task 3

-- CREATE TABLE DropTables (
--     tableName VARCHAR2(20)
-- );

-- CREATE TABLE CommonTables (
--     tableName VARCHAR2(20)
-- );

-- DELETE FROM Tables;
-- DELETE FROM OutputTables;
-- DELETE FROM DropTables;
-- DELETE FROM CommonTables;

-- DECLARE
--     CURSOR devTables IS
--     SELECT * FROM DBA_TABLES
--     WHERE owner = 'DEVUSER';
--     CURSOR prodTables IS
--     SELECT * FROM DBA_TABLES
--     WHERE owner = 'PRODUSER';
--     ch BOOLEAN;
--     c NUMBER;
--     col1 NUMBER;
--     col2 NUMBER;
--     CURSOR differentTables IS
--     SELECT * FROM Tables; 
--     cName VARCHAR2(20);
--     rName VARCHAR2(20); 
--     tName VARCHAR2(20); 
-- BEGIN
--     FOR d IN devTables
--     LOOP
--         ch := FALSE;
--         tName := ' ';
--         FOR p IN prodTables
--         LOOP
--             tName := p.table_name;
--             IF d.table_name = p.table_name THEN
--                 SELECT COUNT(*) INTO col1 FROM dba_tab_columns
--                 WHERE table_name = d.table_name AND owner = 'DEVUSER';
--                 SELECT COUNT(*) INTO col2 FROM dba_tab_columns
--                 WHERE table_name = p.table_name AND owner = 'PRODUSER';
--                 IF col1 = col2 THEN
--                     c := 0;
--                     FOR typesDev IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = d.table_name AND owner = 'DEVUSER')
--                     LOOP
--                         FOR typesProd IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = p.table_name AND owner = 'PRODUSER')
--                         LOOP
--                             IF typesDev.column_name = typesProd.column_name AND typesDev.data_type = typesProd.data_type THEN
--                                 c := c + 1;
--                             END IF;
--                         END LOOP;
--                     END LOOP;
--                     IF c = col1 THEN
--                             ch := TRUE;
--                     ELSE
--                         SELECT COUNT(*) INTO col1 FROM CommonTables 
--                         WHERE tableName = tName; 
--                         SELECT COUNT(*) INTO col2 FROM DropTables 
--                         WHERE tableName = tName; 
--                         IF col1 + col2 = 0 THEN
--                             INSERT INTO DropTables VALUES (tName);
--                         END IF;
--                     END IF;
--                 ELSE
--                     SELECT COUNT(*) INTO col1 FROM CommonTables 
--                     WHERE tableName = tName; 
--                     SELECT COUNT(*) INTO col2 FROM DropTables 
--                     WHERE tableName = tName; 
--                     IF col1 + col2 = 0 THEN
--                         INSERT INTO DropTables VALUES (tName);
--                     END IF;
--                 END IF;
--             ELSE
--                 SELECT COUNT(*) INTO col1 FROM CommonTables 
--                 WHERE tableName = tName; 
--                 SELECT COUNT(*) INTO col2 FROM DropTables 
--                 WHERE tableName = tName; 
--                 IF col1 + col2 = 0 THEN
--                     INSERT INTO DropTables VALUES (tName);
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             INSERT INTO Tables VALUES (d.table_name);
--         ELSE 
--             INSERT INTO CommonTables VALUES (d.table_name);
--         END IF;
--     END LOOP;
--     FOR dr IN (SELECT * FROM DropTables) 
--     LOOP
--         SELECT COUNT(*) INTO col1 FROM CommonTables 
--         WHERE tableName = dr.tableName; 
--         IF col1 = 0 THEN
--             DBMS_OUTPUT.PUT_LINE('DROP TABLE ' ||dr.tableName|| ' ;');
--         END IF;
--     END LOOP; 
--     FOR t in differentTables
--     LOOP
--         SELECT COUNT(*) INTO col1 FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND table_name = t.tableName AND constraint_type = 'R';
--         SELECT COUNT(*) INTO col2 FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND table_name = t.tableName AND constraint_type = 'P';
--         IF col1 = 1 THEN
--             SELECT r_constraint_name INTO cName FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND table_name = t.tableName AND constraint_type = 'R';
--             SELECT table_name INTO rName FROM DBA_CONSTRAINTS WHERE owner = 'DEVUSER' AND constraint_name = cName;
--             -- DBMS_OUTPUT.PUT_LINE(rName);
--             DBMS_OUTPUT.PUT_LINE('CREATE TABLE ' ||rName|| '( ');
--             FOR typesDev IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = rName AND owner = 'DEVUSER')
--             LOOP
--                 DBMS_OUTPUT.PUT_LINE('  ' ||typesDev.column_name|| ' ' ||typesDev.data_type|| ',');
--             END LOOP;
--             DBMS_OUTPUT.PUT_LINE(');');
--             FOR constr IN (SELECT * FROM dba_constraints WHERE owner = 'DEVUSER' AND table_name = rName)
--             LOOP
--                 DBMS_OUTPUT.PUT_LINE('ALTER TABLE ' ||rName|| ' ADD CONSTRAINT ' ||constr.constraint_name|| ' ');
--                 IF constr.constraint_type = 'P' THEN 
--                     SELECT column_name INTO cName FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = constr.constraint_name;
--                     DBMS_OUTPUT.PUT_LINE('PRIMARY KEY ' ||rName|| '(' ||cName||');');
--                 ELSIF constr.constraint_type = 'R' THEN 
--                     SELECT column_name INTO cName FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = constr.constraint_name;
--                     DBMS_OUTPUT.PUT_LINE('FOREIGN KEY ' ||rName|| '(' ||cName||');');
--                     SELECT table_name INTO tName FROM dba_constraints WHERE owner = 'DEVUSER' AND constraint_name = constr.r_constraint_name;
--                     SELECT column_name INTO cName FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = constr.r_constraint_name;
--                     DBMS_OUTPUT.PUT_LINE('REFERENCES ' ||tName|| '(' ||cName|| ');');
--                 END IF;
--                 DBMS_OUTPUT.PUT_LINE(' ');
--             END LOOP;
--             SELECT COUNT(*) INTO col1 FROM OutputTables WHERE tableName = t.tableName;
--             IF col1 = 0 THEN
--                 INSERT INTO OutputTables VALUES (rname);
--             ELSE
--                 DBMS_OUTPUT.PUT_LINE('loopback connections');
--             END IF;
--             -- DELETE FROM Tables WHERE tableName = rName;
--         END IF;
--         SELECT COUNT(*) INTO col1 FROM OutputTables WHERE tableName = t.tableName;
--         IF col1 = 0 AND col2 = 0 THEN
--             DBMS_OUTPUT.PUT_LINE('CREATE TABLE ' ||t.tableName|| '( ');
--             FOR typesDev IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = t.tableName AND owner = 'DEVUSER')
--             LOOP
--                 DBMS_OUTPUT.PUT_LINE('  ' ||typesDev.column_name|| ' ' ||typesDev.data_type|| ',');
--             END LOOP;
--             DBMS_OUTPUT.PUT_LINE(');');
--             FOR constr IN (SELECT * FROM dba_constraints WHERE owner = 'DEVUSER' AND table_name = t.tableName)
--             LOOP
--                 DBMS_OUTPUT.PUT_LINE('ALTER TABLE ' ||t.tableName|| ' ADD CONSTRAINT ' ||constr.constraint_name|| ' ');
--                 IF constr.constraint_type = 'P' THEN 
--                     SELECT column_name INTO cName FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = constr.constraint_name;
--                     DBMS_OUTPUT.PUT_LINE('PRIMARY KEY ' ||t.tableName|| '(' ||cName||');');
--                 ELSIF constr.constraint_type = 'R' THEN 
--                     SELECT column_name INTO cName FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = constr.constraint_name;
--                     DBMS_OUTPUT.PUT_LINE('FOREIGN KEY ' ||t.tableName|| '(' ||cName||');');
--                     SELECT table_name INTO tName FROM dba_constraints WHERE owner = 'DEVUSER' AND constraint_name = constr.r_constraint_name;
--                     SELECT column_name INTO cName FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = constr.r_constraint_name;
--                     DBMS_OUTPUT.PUT_LINE('REFERENCES ' ||tName|| '(' ||cName|| ');');
--                 END IF;
--                 DBMS_OUTPUT.PUT_LINE(' ');
--             END LOOP;
--             INSERT INTO OutputTables VALUES (t.tableName);
--             DBMS_OUTPUT.PUT_LINE(' ');
--         END IF;
--     END LOOP;  
-- END;

-- DELETE FROM DropTables;
-- DELETE FROM CommonTables;

-- DECLARE
--     CURSOR devProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'DEVUSER' AND object_type = 'PROCEDURE';
--     CURSOR prodProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'PRODUSER' AND object_type = 'PROCEDURE';
--     ch BOOLEAN;
--     c NUMBER;
--     lines NUMBER;
--     line NUMBER := -1;
--     ps VARCHAR2(80);
--     col1 NUMBER;
--     col2 NUMBER;
-- BEGIN
--     FOR d IN devProc 
--     LOOP
--         ch := FALSE;
--         FOR p IN prodProc
--         LOOP
--             IF d.object_name = p.object_name THEN
--                 c := 0;
--                 SELECT COUNT(*) INTO lines FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = d.object_name;
--                 FOR ds IN (SELECT * FROM ALL_SOURCE WHERE owner = 'DEVUSER' AND name = d.object_name)
--                 LOOP
--                     IF ds.line < lines + 1 THEN
--                         SELECT text INTO ps FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = ds.name AND line = ds.line;
--                         IF SUBSTR(ds.text, 1, 4) <> 'END;' THEN
--                             IF ds.text = ps THEN
--                                 c := c + 1;
--                             END IF;
--                         END IF;
--                         IF SUBSTR(ds.text, 1, 4) = 'END;' AND SUBSTR(ps, 1, 4) = 'END;' THEN
--                             line := ds.line;
--                             c := c + 1;
--                             EXIT;
--                         END IF;
--                     END IF;
--                 END LOOP;
--                 IF c = line THEN
--                     ch := TRUE;
--                 ELSE
--                     SELECT COUNT(*) INTO col1 FROM CommonTables 
--                     WHERE tableName = p.object_name; 
--                     SELECT COUNT(*) INTO col2 FROM DropTables 
--                     WHERE tableName = p.object_name; 
--                     IF col1 + col2 = 0 THEN
--                         INSERT INTO DropTables VALUES (p.object_name);
--                     END IF;
--                 END IF;
--             ELSE
--                 SELECT COUNT(*) INTO col1 FROM CommonTables 
--                 WHERE tableName = p.object_name; 
--                 SELECT COUNT(*) INTO col2 FROM DropTables 
--                 WHERE tableName = p.object_name; 
--                 IF col1 + col2 = 0 THEN
--                     INSERT INTO DropTables VALUES (p.object_name);
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             DBMS_OUTPUT.PUT_LINE('CREATE');
--             FOR ds IN (SELECT * FROM ALL_SOURCE WHERE owner = 'DEVUSER' AND name = d.object_name)
--             LOOP
--                 IF SUBSTR(ds.text, 1, 4) = 'END;' THEN
--                     DBMS_OUTPUT.PUT_LINE(ds.text);
--                     EXIT;
--                 ELSE
--                     DBMS_OUTPUT.PUT_LINE(ds.text);
--                 END IF;
--             END LOOP;
--         ELSE
--             INSERT INTO CommonTables VALUES (d.object_name);
--         END IF;
--     END LOOP;
--     FOR dr IN (SELECT * FROM DropTables) 
--     LOOP
--         SELECT COUNT(*) INTO col1 FROM CommonTables 
--         WHERE tableName = dr.tableName; 
--         IF col1 = 0 THEN
--             DBMS_OUTPUT.PUT_LINE('DROP PROCEDURE ' ||dr.tableName|| '; ');
--         END IF;
--     END LOOP; 
-- END;

-- DELETE FROM DropTables;
-- DELETE FROM CommonTables;

-- DECLARE
--     CURSOR devProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'DEVUSER' AND object_type = 'FUNCTION';
--     CURSOR prodProc IS
--     SELECT * FROM DBA_PROCEDURES
--     WHERE owner = 'PRODUSER' AND object_type = 'FUNCTION';
--     ch BOOLEAN;
--     c NUMBER;
--     lines NUMBER;
--     line NUMBER := -1;
--     ps VARCHAR2(80);
--     col1 NUMBER;
--     col2 NUMBER;
-- BEGIN
--     FOR d IN devProc 
--     LOOP
--         ch := FALSE;
--         FOR p IN prodProc
--         LOOP
--             IF d.object_name = p.object_name THEN
--                 c := 0;
--                 SELECT COUNT(*) INTO lines FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = d.object_name;
--                 FOR ds IN (SELECT * FROM ALL_SOURCE WHERE owner = 'DEVUSER' AND name = d.object_name)
--                 LOOP
--                     IF ds.line < lines + 1 THEN
--                         SELECT text INTO ps FROM ALL_SOURCE WHERE owner = 'PRODUSER' AND name = ds.name AND line = ds.line;
--                         IF SUBSTR(ds.text, 1, 4) <> 'END;' THEN
--                             IF ds.text = ps THEN
--                                 c := c + 1;
--                             END IF;
--                         END IF;
--                         IF SUBSTR(ds.text, 1, 4) = 'END;' AND SUBSTR(ps, 1, 4) = 'END;' THEN
--                             line := ds.line;
--                             c := c + 1;
--                             EXIT;
--                         END IF;
--                     END IF;
--                 END LOOP;
--                 IF c = line THEN
--                     ch := TRUE;
--                 ELSE
--                     SELECT COUNT(*) INTO col1 FROM CommonTables 
--                     WHERE tableName = p.object_name; 
--                     SELECT COUNT(*) INTO col2 FROM DropTables 
--                     WHERE tableName = p.object_name; 
--                     IF col1 + col2 = 0 THEN
--                         INSERT INTO DropTables VALUES (p.object_name);
--                     END IF;
--                 END IF;
--             ELSE
--                 SELECT COUNT(*) INTO col1 FROM CommonTables 
--                 WHERE tableName = p.object_name; 
--                 SELECT COUNT(*) INTO col2 FROM DropTables 
--                 WHERE tableName = p.object_name; 
--                 IF col1 + col2 = 0 THEN
--                     INSERT INTO DropTables VALUES (p.object_name);
--                 END IF;
--             END IF;
--         END LOOP;
--         IF ch = FALSE THEN
--             DBMS_OUTPUT.PUT_LINE('CREATE');
--             FOR ds IN (SELECT * FROM ALL_SOURCE WHERE owner = 'DEVUSER' AND name = d.object_name)
--             LOOP
--                 IF SUBSTR(ds.text, 1, 4) = 'END;' THEN
--                     DBMS_OUTPUT.PUT_LINE(ds.text);
--                     EXIT;
--                 ELSE
--                     DBMS_OUTPUT.PUT_LINE(ds.text);
--                 END IF;
--             END LOOP;
--         ELSE
--             INSERT INTO CommonTables VALUES (d.object_name);
--         END IF;
--     END LOOP;
--     FOR dr IN (SELECT * FROM DropTables) 
--     LOOP
--         SELECT COUNT(*) INTO col1 FROM CommonTables 
--         WHERE tableName = dr.tableName; 
--         IF col1 = 0 THEN
--             DBMS_OUTPUT.PUT_LINE('DROP FUNCTION ' ||dr.tableName|| '; ');
--         END IF;
--     END LOOP; 
-- END;

DELETE FROM DropTables;
DELETE FROM CommonTables;

DECLARE
    CURSOR devIndexes IS
    SELECT * FROM ALL_IND_COLUMNS
    WHERE index_owner = 'DEVUSER';
    CURSOR prodIndexes IS
    SELECT * FROM ALL_IND_COLUMNS
    WHERE index_owner = 'PRODUSER';
    ch BOOLEAN;
    c NUMBER;
    col1 NUMBER;
    col2 NUMBER;
BEGIN
    FOR d IN devIndexes
    LOOP
        ch := FALSE;
        FOR p IN prodIndexes
        LOOP
            IF d.index_name = p.index_name THEN
                IF d.table_name = p.table_name THEN
                    IF d.column_name = p.column_name THEN
                            ch := TRUE;
                    ELSE
                        SELECT COUNT(*) INTO col1 FROM CommonTables 
                        WHERE tableName = p.index_name; 
                        SELECT COUNT(*) INTO col2 FROM DropTables 
                        WHERE tableName = p.index_name; 
                        IF col1 + col2 = 0 THEN
                            INSERT INTO DropTables VALUES (p.index_name);
                        END IF;
                    END IF;
                ELSE
                    SELECT COUNT(*) INTO col1 FROM CommonTables 
                    WHERE tableName = p.index_name; 
                    SELECT COUNT(*) INTO col2 FROM DropTables 
                    WHERE tableName = p.index_name; 
                        IF col1 + col2 = 0 THEN
                            INSERT INTO DropTables VALUES (p.index_name);
                        END IF;
                END IF;
            ELSE
                SELECT COUNT(*) INTO col1 FROM CommonTables 
                WHERE tableName = p.index_name; 
                SELECT COUNT(*) INTO col2 FROM DropTables 
                WHERE tableName = p.index_name; 
                IF col1 + col2 = 0 THEN
                    INSERT INTO DropTables VALUES (p.index_name);
                END IF;
            END IF;
        END LOOP;
        IF ch = FALSE THEN
            IF SUBSTR(d.index_name, 1, 3) <> 'BIN' THEN
                SELECT COUNT(*) INTO c FROM all_cons_columns WHERE owner = 'DEVUSER' AND constraint_name = d.index_name;
                IF c = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('CREATE INDEX ' ||d.index_name|| ' ON ' ||d.table_name|| '(' ||d.column_name|| ')');
                END IF;
            END IF;
        ELSE
            INSERT INTO CommonTables VALUES (d.index_name);
        END IF;
    END LOOP;
    FOR dr IN (SELECT * FROM DropTables) 
    LOOP
        SELECT COUNT(*) INTO col1 FROM CommonTables 
        WHERE tableName = dr.tableName; 
        IF col1 = 0 THEN
            DBMS_OUTPUT.PUT_LINE('DROP INDEX ' ||dr.tableName|| '; ');
        END IF;
    END LOOP; 
END;