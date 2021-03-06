DROP TABLE CUSTOMER;

CREATE TABLE CUSTOMER
(
   CUST_NO     NUMBER (4) PRIMARY KEY,
   CUST_NAME   VARCHAR2 (15),
   ADDRESS     VARCHAR2 (15) NOT NULL,
   EMAIL       VARCHAR2 (15)
);

DROP TABLE SALESMAN;

CREATE TABLE SALESMAN
(
   SALESMAN_NO        NUMBER (3) PRIMARY KEY,
   SALESMAN_NAME      VARCHAR2 (15),
   TELEPHONE          NUMBER (12),
   NO_OF_BIKES_SOLD   NUMBER (2)
);

DROP TABLE SALES_BIKE;

CREATE TABLE SALES_BIKE
(
   BIKE_TRANS_NO   NUMBER (4) PRIMARY KEY,
   SALESMAN_NO     NUMBER (3),
   CUST_NO         NUMBER (4),
   DATE_OF_SALES   DATE,
   SALES_AMT       NUMBER (12, 2),
   CONSTRAINT FK_SALESMAN_NO FOREIGN KEY
      (SALESMAN_NO)
       REFERENCES SALESMAN (SALESMAN_NO),
   CONSTRAINT FK_CUST_NO FOREIGN KEY (CUST_NO) REFERENCES CUSTOMER (CUST_NO),
   CONSTRAINT CHK_SALES_AMT CHECK (SALES_AMT > 0)
);

DROP TABLE INCENTIVE;

CREATE TABLE INCENTIVE
(
   SALESMAN_NO     NUMBER (3),
   BIKE_TRANS_NO   NUMBER (4),
   INCENTIVE       NUMBER (10, 2),
   CONSTRAINT FK_SALESMAN_NO_1 FOREIGN KEY
      (SALESMAN_NO)
       REFERENCES SALESMAN (SALESMAN_NO),
   CONSTRAINT FK_BIKE_TRANS_NO FOREIGN KEY
      (BIKE_TRANS_NO)
       REFERENCES SALES_BIKE (BIKE_TRANS_NO)
);

-- 1. CREATE A SEQUENCE TO GENERATE CUSTOMER NO.

CREATE SEQUENCE SEQ_CUST_NO MINVALUE 1
                            MAXVALUE 999999999999999999999999999
                            START WITH 1000
                            INCREMENT BY 1
                            CACHE 20;

-- 2. CREATE A SEQUENCE TO GENERATE BIKE TRANSACTION NO.

CREATE SEQUENCE SEQ_BIKE_TRAN_NO MINVALUE 1
                                 MAXVALUE 999999999999999999999999999
                                 START WITH 10
                                 INCREMENT BY 1
                                 CACHE 20;

-- 3. CREATE A PACKAGE CTE_BIKES.

CREATE OR REPLACE PACKAGE CTE_BIKES
IS
   FUNCTION SP_SALESBIKE (P_CUST_NO        NUMBER,
                          P_SALESMAN_NO    NUMBER,
                          P_SALES_AMT      NUMBER)
      RETURN VARCHAR2;

   PROCEDURE P_TOTAL_SALES;

   PROCEDURE P_SALESMAN_DETAIL (P_SALESMAN_NO NUMBER);

   FUNCTION F_TOTAL_SALES_DATE (P_DATE_OF_SALES DATE)
      RETURN NUMBER;
END CTE_BIKES;
/

CREATE OR REPLACE PACKAGE BODY CTE_BIKES
IS
   FUNCTION SP_SALESBIKE (P_CUST_NO        NUMBER,
                          P_SALESMAN_NO    NUMBER,
                          P_SALES_AMT      NUMBER)
      RETURN VARCHAR2
   IS
      V_COUNT_CUST_NO       NUMBER;
      V_COUNT_SALESMAN_NO   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO V_COUNT_CUST_NO
        FROM CUSTOMER
       WHERE CUST_NO = P_CUST_NO;

      IF V_COUNT_CUST_NO <> 0
      THEN
         SELECT COUNT (*)
           INTO V_COUNT_SALESMAN_NO
           FROM SALESMAN
          WHERE SALESMAN_NO = P_SALESMAN_NO;

         IF V_COUNT_SALESMAN_NO <> 0
         THEN
            INSERT INTO SALES_BIKE (BIKE_TRANS_NO,
                                    SALESMAN_NO,
                                    CUST_NO,
                                    DATE_OF_SALES,
                                    SALES_AMT)
                 VALUES (SEQ_BIKE_TRAN_NO.NEXTVAL,
                         P_SALESMAN_NO,
                         P_CUST_NO,
                         SYSDATE,
                         P_SALES_AMT);

            IF P_SALES_AMT > 25000
            THEN
               INSERT INTO INCENTIVE (SALESMAN_NO, BIKE_TRANS_NO, INCENTIVE)
                       VALUES (
                                 P_SALESMAN_NO,
                                 SEQ_BIKE_TRAN_NO.CURRVAL,
                                 (P_SALES_AMT * 15) / 100);
            ELSE
               DBMS_OUTPUT.PUT_LINE ('CANNOT ADD INCENTIVES');
            END IF;

            RETURN 'SUCCESS';
         ELSE
            RETURN '-2';
         END IF;
      ELSE
         RETURN '-1';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'NO DATA FOUND';
      WHEN OTHERS
      THEN
         RETURN '-3';
   END SP_SALESBIKE;

   PROCEDURE P_TOTAL_SALES
   IS
      V_TOTAL_SALES   NUMBER;
   BEGIN
      SELECT SUM (SALES_AMT) INTO V_TOTAL_SALES FROM SALES_BIKE;

      DBMS_OUTPUT.PUT_LINE ('TOTAL SALES IS: ' || V_TOTAL_SALES);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.PUT_LINE ('NO DATA FOUND');
   END P_TOTAL_SALES;

   PROCEDURE P_SALESMAN_DETAIL (P_SALESMAN_NO NUMBER)
   IS
      V_SALESMAN_NO        NUMBER (3);
      V_SALESMAN_NAME      VARCHAR2 (15);
      V_TELEPHONE          NUMBER (12);
      V_NO_OF_BIKES_SOLD   NUMBER (2);
   BEGIN
      SELECT SALESMAN_NO,
             SALESMAN_NAME,
             TELEPHONE,
             NO_OF_BIKES_SOLD
        INTO V_SALESMAN_NO,
             V_SALESMAN_NAME,
             V_TELEPHONE,
             V_NO_OF_BIKES_SOLD
        FROM SALESMAN
       WHERE SALESMAN_NO = P_SALESMAN_NO;

      DBMS_OUTPUT.PUT_LINE ('SALESMAN DETAILS ARE ');
      DBMS_OUTPUT.PUT_LINE ('SALESMAN NUMBER IS: ' || V_SALESMAN_NO);
      DBMS_OUTPUT.PUT_LINE ('SALESMAN NAME IS: ' || V_SALESMAN_NAME);
      DBMS_OUTPUT.PUT_LINE ('SALESMAN NUMBER IS: ' || V_TELEPHONE);
      DBMS_OUTPUT.PUT_LINE (
         'TOTAL BIKES SOLD BY SALESMAN IS: ' || V_NO_OF_BIKES_SOLD);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.PUT_LINE ('NO DATA FOUND');
   END P_SALESMAN_DETAIL;

   FUNCTION F_TOTAL_SALES_DATE (P_DATE_OF_SALES DATE)
      RETURN NUMBER
   IS
      V_DATE_OF_SALES   DATE := TO_DATE (P_DATE_OF_SALES, 'DD-MON-YYYY');
      V_TOTAL_SALES     NUMBER;
   BEGIN
      SELECT SUM (SALES_AMT)
        INTO V_TOTAL_SALES
        FROM SALES_BIKE
       WHERE TO_DATE (DATE_OF_SALES, 'DD-MON-YYYY') = V_DATE_OF_SALES;

      DBMS_OUTPUT.PUT_LINE (
         'TOTAL SALES ON DATE: ' || V_DATE_OF_SALES || ' IS ');

      IF V_TOTAL_SALES <> 0 OR V_TOTAL_SALES <> NULL
      THEN
         RETURN V_TOTAL_SALES;
      ELSE
         RETURN 0;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END F_TOTAL_SALES_DATE;
END;
/

-- 4. TRIGGER THAT UPDATES THE NO_OF_BIKES_SOLD

CREATE TRIGGER TRIGGER_UPDATE
   AFTER INSERT
   ON SALES_BIKE
   FOR EACH ROW
BEGIN
   UPDATE SALESMAN
      SET NO_OF_BIKES_SOLD = NO_OF_BIKES_SOLD + 1
    WHERE SALESMAN_NO = :NEW.SALESMAN_NO;
END;
/
