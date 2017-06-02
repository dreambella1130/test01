
-- 회원정보 번호 시퀀스 생성
CREATE SEQUENCE SEQ_MEM_INFO START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;
-- 공통구분 번호 시퀀스 생성
CREATE SEQUENCE SEQ_GUBUN START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;
-- 게시판 번호 시퀀스 생성
CREATE SEQUENCE SEQ_BOARD START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;
-- 게시판 댓글 시퀀스 생성
CREATE SEQUENCE SEQ_BD_REPL START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;
-- 게시판 첨부 시퀀스 생성
CREATE SEQUENCE SEQ_BD_FILE START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;

-- 게시판 추천&신고 시퀀스 생성 
CREATE SEQUENCE SEQ_BOARD_VOTE START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCACHE;


-- 회원정보 입력
INSERT INTO MEM_INFO(MEM_SID, MEM_ID, MEM_PW, MEM_NICK, MEM_REGI, MEM_UPDT, MEM_BL, MEM_GRADE)
VALUES(SEQ_MEM_INFO.NEXTVAL, 'bellabella1130@naver.com', '1111@', 'MOON', SYSDATE, SYSDATE, 'N', '9');

SELECT *
FROM MEM_INFO;

-- 공통구분 입력
INSERT INTO GUBUN(GUBUN_SID, GUBUN_CATE, GUBUN_DETAIL, GUBUN_REGI, GUBUN_UPDT)
VALUES(SEQ_GUBUN.NEXTVAL, '게시판', '자유게시판', SYSDATE, SYSDATE);

INSERT INTO GUBUN(GUBUN_SID, GUBUN_CATE, GUBUN_DETAIL, GUBUN_REGI, GUBUN_UPDT)
VALUES(SEQ_GUBUN.NEXTVAL, '투표', '추천', SYSDATE, SYSDATE);
INSERT INTO GUBUN(GUBUN_SID, GUBUN_CATE, GUBUN_DETAIL, GUBUN_REGI, GUBUN_UPDT)
VALUES(SEQ_GUBUN.NEXTVAL, '투표', '신고', SYSDATE, SYSDATE);

SELECT *
FROM GUBUN
ORDER BY 1;

-- 게시글 입력
INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(SEQ_BOARD.NEXTVAL, 1, 1, 0, 1, '제목 테스트', '내용 테스트', SYSDATE, SYSDATE, 0, 'N', 5, 0, 1);

INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(SEQ_BOARD.NEXTVAL, 1, 2, 1, 1, 'RE: 제목 테스트', '내용 테스트', SYSDATE, SYSDATE, 0, 'N', 0, 0, 1);

INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(SEQ_BOARD.NEXTVAL, 1, 3, 2, 1, 'RE: RE: 제목 테스트', 'RE: RE: 내용 테스트', SYSDATE, SYSDATE, 0, 'N', 0, 0, 1);

INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(SEQ_BOARD.NEXTVAL, 1, 4, 1, 1, 'RE: 2. 제목 테스트', 'RE: 2. 내용 테스트', SYSDATE, SYSDATE, 0, 'N', 0, 0, 1);


INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(20, 15, 2, 1, 1, 'RE: 게시글', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.', SYSDATE, SYSDATE, 0, 'N', 0, 0, 1);

INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(22, 15, 3, 2, 1, 'RE: RE: 게시글', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.', SYSDATE, SYSDATE, 0, 'Y', 0, 0, 1);

-- 답글 INSERT 쿼리문
INSERT INTO BOARD(BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, GUBUN_SID, BD_TITLE, BD_CONT, BD_REGI, BD_UPDT, BD_CLI, BD_DELCK, BD_LIKE, BD_BLCK, MEM_SID)
VALUES(24, 23, (1+1), (0+1), 1, '제목', '내용', SYSDATE, SYSDATE, 0, 'N', 0, 0, 1);

-- 답글 작성 시 답글 그룹의 순서 재배치 하기
UPDATE BOARD
SET BD_GRP_LV = BD_GRP_LV + 1
WHERE BD_GRP_SID = 1 AND BD_GRP_LV > 2;

-- 게시글 추천 숫자 올리기
UPDATE BOARD
SET BD_LIKE = BD_LIKE+1
WHERE BD_SID = 1;

SELECT *
FROM BOARD
ORDER BY BD_GRP_SID DESC, BD_GRP_LV;

-- 게시글 번호 얻기
SELECT SEQ_BOARD.NEXTVAL FROM DUAL;


-- 게시글 수정하기
UPDATE BOARD
SET BD_TITLE = '제목 수정', BD_CONT = '내용 수정'
WHERE BD_SID = 1;


-- 게시판 전체 목록 조회
SELECT*
FROM
(
    SELECT ROW_NUMBER() OVER(ORDER BY BD_GRP_SID DESC, BD_GRP_LV) AS "NUM"
        , BD_SID, BD_GRP_SID, BD_GRP_LV, BD_GRP_DEP, BD_TITLE
        , CASE TO_CHAR(SYSDATE, 'YYYYMMDD') WHEN TO_CHAR(BD_REGI, 'YYYYMMDD') THEN TO_CHAR(BD_REGI, 'HH24:MI')
            ELSE TO_CHAR(BD_REGI, 'YY.MM.DD')
            END AS "BD_REGI"
        , (SELECT COUNT(*) FROM BD_REPL B WHERE B.BD_SID = A.BD_SID) AS "REPLCOUNT"
        , BD_CLI, BD_DELCK
        , (SELECT MEM_NICK FROM MEM_INFO A WHERE A.MEM_SID = MEM_SID) AS "MEM_NICK"
        , MEM_SID, BD_LIKE, BD_BLCK
    FROM BOARD A
    WHERE BD_DELCK = 'N'
)
WHERE NUM BETWEEN 1 AND 10;


-- 다음글 구하기_1
SELECT BD_SID, BD_GRP_SID, BD_GRP_LV, BD_TITLE
    , CASE TO_CHAR(SYSDATE, 'YYYYMMDD') WHEN TO_CHAR(BD_REGI, 'YYYYMMDD') THEN TO_CHAR(BD_REGI, 'HH24:MI')
        ELSE TO_CHAR(BD_REGI, 'YYYY.MM.DD')
        END AS "BD_REGI"
    , CASE WHEN BD_BLCK < 1 THEN 'N'
            ELSE 'Y'
        END AS "BD_BLCK"
FROM BOARD
WHERE BD_GRP_SID = 1 AND BD_GRP_LV = (2-1) AND BD_DELCK = 'N';


-- 다음글 구하기_2
--==> 다음글 구하기_1에서 조회되는 결과가 없으면

SELECT BD_SID, BD_GRP_SID, BD_GRP_LV, BD_TITLE
    , CASE TO_CHAR(SYSDATE, 'YYYYMMDD') WHEN TO_CHAR(BD_REGI, 'YYYYMMDD') THEN TO_CHAR(BD_REGI, 'HH24:MI')
        ELSE TO_CHAR(BD_REGI, 'YYYY.MM.DD')
        END AS "BD_REGI"
    , CASE WHEN BD_BLCK < 1 THEN 'N'
            ELSE 'Y'
        END AS "BD_BLCK"
FROM BOARD
WHERE BD_GRP_SID =
    (
        SELECT MIN(BD_GRP_SID)
        FROM BOARD
        WHERE BD_GRP_SID > 1 AND BD_DELCK = 'N'
    )
AND BD_GRP_LV = 
    (
        SELECT MAX(BD_GRP_LV)
        FROM BOARD
        WHERE BD_GRP_SID =
        (
            SELECT MIN(BD_GRP_SID)
            FROM BOARD
            WHERE BD_GRP_SID > 1 AND BD_DELCK = 'N'
        )
        AND BD_DELCK = 'N'
    );


-- 이전글 구하기_1
SELECT BD_SID, BD_GRP_SID, BD_GRP_LV, BD_TITLE
    , CASE TO_CHAR(SYSDATE, 'YYYYMMDD') WHEN TO_CHAR(BD_REGI, 'YYYYMMDD') THEN TO_CHAR(BD_REGI, 'HH24:MI')
        ELSE TO_CHAR(BD_REGI, 'YYYY.MM.DD')
        END AS "BD_REGI"
    , CASE WHEN BD_BLCK < 1 THEN 'N'
            ELSE 'Y'
        END AS "BD_BLCK"
FROM BOARD
WHERE BD_GRP_SID = 19 AND BD_GRP_LV = (1+1) AND BD_DELCK = 'N';


-- 이전글 구하기_2
--==> 이전글 구하기_1에서 조회되는 결과가 없으면

SELECT BD_SID, BD_GRP_SID, BD_GRP_LV, BD_TITLE
    , CASE TO_CHAR(SYSDATE, 'YYYYMMDD') WHEN TO_CHAR(BD_REGI, 'YYYYMMDD') THEN TO_CHAR(BD_REGI, 'HH24:MI')
        ELSE TO_CHAR(BD_REGI, 'YYYY.MM.DD')
        END AS "BD_REGI"
    , CASE WHEN BD_BLCK < 1 THEN 'N'
            ELSE 'Y'
        END AS "BD_BLCK"
FROM BOARD
WHERE BD_GRP_SID =
    (
        SELECT MAX(BD_GRP_SID)
        FROM BOARD
        WHERE BD_GRP_SID < 19 AND BD_DELCK = 'N'
    )
AND BD_GRP_LV = 
    (
        SELECT MIN(BD_GRP_LV)
        FROM BOARD
        WHERE BD_GRP_SID =
        (
            SELECT MAX(BD_GRP_SID)
            FROM BOARD
            WHERE BD_GRP_SID < 19 AND BD_DELCK = 'N'
        )
        AND BD_DELCK = 'N'
    );



-- 총 게시글 갯수
SELECT COUNT(*) AS "GESITOT"
FROM BOARD;

-- 게시판 상세 내역 조회
SELECT BD_SID, BD_TITLE, BD_GRP_SID, BD_GRP_LV
    , (SELECT MEM_NICK FROM MEM_INFO A WHERE A.MEM_SID = MEM_SID) AS "MEM_NICK"
    , BD_CLI
    , BD_LIKE
    , TO_CHAR(BD_REGI, 'YYYY.MM.DD HH24:MI') AS "BD_REGI"
    , BD_CONT
    , (SELECT COUNT(*) FROM BD_REPL B WHERE B.BD_SID = 3) AS "REPLCOUNT"
FROM BOARD
WHERE BD_SID = 3;

SELECT *
FROM BOARD
ORDER BY BD_GRP_SID DESC, BD_GRP_LV;

UPDATE BOARD
SET BD_DELCK = 'Y'
WHERE BD_SID = 3;


UPDATE BOARD
SET BD_BLCK = BD_BLCK+1
WHERE BD_SID = 1;

SELECT SEQ_BD_REPL.NEXTVAL FROM DUAL;

-- 댓글 입력
INSERT INTO BD_REPL(REPL_SID, REPL_GRP, REPL_LV, REPL_DEPT, REPL_CONT, REPL_REGI, REPL_UPDT, REPL_DELCK, REPL_BLCK, BD_SID, MEM_SID)
VALUES(2, 2, 1, 0, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.', SYSDATE, SYSDATE, 'N', 0, 1, 1);
INSERT INTO BD_REPL(REPL_SID, REPL_GRP, REPL_LV, REPL_DEPT, REPL_CONT, REPL_REGI, REPL_UPDT, REPL_DELCK, REPL_BLCK, BD_SID, MEM_SID)
VALUES(3, 3, 1, 0, 'Dolorem tempore commodi atque ipsa repudiandae debitis sapiente molestiae quam dicta non quasi corporis amet maiores?', SYSDATE, SYSDATE, 'N', 0, 1, 1);
INSERT INTO BD_REPL(REPL_SID, REPL_GRP, REPL_LV, REPL_DEPT, REPL_CONT, REPL_REGI, REPL_UPDT, REPL_DELCK, REPL_BLCK, BD_SID, MEM_SID)
VALUES(4, 2, 2, 1, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.', SYSDATE, SYSDATE, 'N', 0, 1, 1);
INSERT INTO BD_REPL(REPL_SID, REPL_GRP, REPL_LV, REPL_DEPT, REPL_CONT, REPL_REGI, REPL_UPDT, REPL_DELCK, REPL_BLCK, BD_SID, MEM_SID)
VALUES(6, 2, 3, 2, 'tempore voluptas nesciunt blanditiis facilis inventore dignissimos maxime necessitatibus cupiditate nostrum.', SYSDATE, SYSDATE, 'N', 0, 1, 1);



-- 댓글 조회
SELECT REPL_SID, REPL_GRP, REPL_LV, REPL_DEPT, REPL_CONT
    , CASE TO_CHAR(SYSDATE, 'YYYYMMDD') WHEN TO_CHAR(REPL_REGI, 'YYYYMMDD') THEN TO_CHAR(REPL_REGI, 'HH24:MI')
        ELSE TO_CHAR(REPL_REGI, 'YY.MM.DD')
        END AS "REPL_REGI"
    , REPL_DELCK, REPL_BLCK, BD_SID
    , (SELECT MEM_NICK FROM MEM_INFO WHERE MEM_SID = A.MEM_SID) AS "MEM_NICK"
    , MEM_SID
FROM BD_REPL A
WHERE BD_SID = 1
ORDER BY REPL_GRP, REPL_LV;

UPDATE BD_REPL
SET REPL_CONT = '수정내용'
WHERE REPL_SID = 23;

DELETE BD_REPL
WHERE REPL_SID = 23;

SELECT *
FROM BD_REPL;

DESC BD_REPL;

UPDATE BD_REPL
SET REPL_BLCK = 'N'
WHERE BD_SID = 3;

-- 게시판 추천&신고 이력
-- GUBUN_SID - 2: 투표-추천 / 3: 투표-신고
-- 추천 INSERT
INSERT INTO BOARD_VOTE(BD_VOTE_SID, BD_VOTE_IP, MEM_SID, BD_VOTE_REGI, BD_SID, GUBUN_SID)
VALUES(SEQ_BOARD_VOTE.NEXTVAL, '125.7.234.15', 1, SYSDATE, 1, 2);
INSERT INTO BOARD_VOTE(BD_VOTE_SID, BD_VOTE_IP, MEM_SID, BD_VOTE_REGI, BD_SID, GUBUN_SID)
VALUES(SEQ_BOARD_VOTE.NEXTVAL, '125.7.234.16', NULL, SYSDATE, 1, 2);
INSERT INTO BOARD_VOTE(BD_VOTE_SID, BD_VOTE_IP, MEM_SID, BD_VOTE_REGI, BD_SID, GUBUN_SID)
VALUES(SEQ_BOARD_VOTE.NEXTVAL, '125.7.234.17', NULL, SYSDATE, 1, 2);
INSERT INTO BOARD_VOTE(BD_VOTE_SID, BD_VOTE_IP, MEM_SID, BD_VOTE_REGI, BD_SID, GUBUN_SID)
VALUES(SEQ_BOARD_VOTE.NEXTVAL, '125.7.234.18', NULL, SYSDATE, 1, 2);
INSERT INTO BOARD_VOTE(BD_VOTE_SID, BD_VOTE_IP, MEM_SID, BD_VOTE_REGI, BD_SID, GUBUN_SID)
VALUES(SEQ_BOARD_VOTE.NEXTVAL, '125.7.234.19', NULL, SYSDATE, 1, 2);

-- 신고 INSERT
INSERT INTO BOARD_VOTE(BD_VOTE_SID, BD_VOTE_IP, MEM_SID, BD_VOTE_REGI, BD_SID, GUBUN_SID)
VALUES(SEQ_BOARD_VOTE.NEXTVAL, '125.7.234.15', 1, SYSDATE, 2, 3);


SELECT *
FROM BOARD_VOTE
ORDER BY BD_VOTE_REGI;

DESC BOARD_VOTE;

SELECT *
FROM BOARD;


SELECT COUNT(*) AS "COUNT"
FROM BOARD_VOTE
WHERE BD_SID = 1 AND GUBUN_SID = 2 AND (BD_VOTE_IP = '125.7.234.15' OR MEM_SID = 1);

SELECT BD_LIKE
FROM BOARD
WHERE BD_SID = 37;










