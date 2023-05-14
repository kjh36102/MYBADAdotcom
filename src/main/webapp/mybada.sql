-- DB 생성
CREATE DATABASE IF NOT EXISTS mybada;
USE mybada;


CREATE TABLE IF NOT EXISTS questions(
    id INT AUTO_INCREMENT PRIMARY KEY,
    question varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS puser(
    hashcode CHAR(6) PRIMARY KEY,
    email VARCHAR(50) NOT NULL UNIQUE CHECK (email LIKE '_%@_%._%'),
    password VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    question_id INT NOT NULL,
    answer VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE IF NOT EXISTS friends (
    user_id CHAR(6),
    friend_id CHAR(6),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES puser (hashcode),
    FOREIGN KEY (friend_id) REFERENCES puser (hashcode)
);

CREATE TABLE IF NOT EXISTS pfeed(
    id INT AUTO_INCREMENT PRIMARY KEY,
    hashcode CHAR(6) NOT NULL,
    content VARCHAR(300) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hashcode) REFERENCES puser(hashcode)
);

-- 랜덤한 6자리 코드를 생성하는 함수
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS RAND_HASH() RETURNS CHAR(6) READS SQL DATA
BEGIN
  DECLARE unique_hash CHAR(6);
  DECLARE counter INT DEFAULT 0;
  
  REPEAT
    SET unique_hash = SUBSTRING(REGEXP_REPLACE(TO_BASE64(RANDOM_BYTES(4)), '[+/=]', ''), 1, 6);
    SET counter = (SELECT COUNT(*) FROM puser WHERE hashcode = unique_hash);
  UNTIL counter = 0
  END REPEAT;
  
  RETURN unique_hash;
END$$
DELIMITER ;

INSERT INTO questions(question) values("당신이 태어난 도시 이름은?");
INSERT INTO questions(question) values("당신이 가장 좋아하는 음식은?");
INSERT INTO questions(question) values("당신이 졸업한 초등학교 이름은?");
INSERT INTO questions(question) values("당신의 첫 애완동물의 이름은?");
INSERT INTO questions(question) values("당신이 가장 좋아하는 색깔은?");
INSERT INTO questions(question) values("당신이 가장 좋아하는 장소는?");
INSERT INTO questions(question) values("당신이 가장 좋아하는 캐릭터는?");
INSERT INTO questions(question) values("당신이 가장 싫어하는 것은?");
INSERT INTO questions(question) values("당신의 첫 연애는 몇 년도에?");
INSERT INTO questions(question) values("당신의 최대 자랑거리는?");

INSERT INTO puser(hashcode, email, password, name, question_id, answer)
values(RAND_HASH(), "melon@abc.com", "1111", "Melon", 1, "멜론");
INSERT INTO puser(hashcode, email, password, name, question_id, answer)
values(RAND_HASH(), "banana@abc.com", "2222", "Banana", 2, "바나나");
INSERT INTO puser(hashcode, email, password, name, question_id, answer)
values(RAND_HASH(), "spider@abc.com", "3333", "Spider", 3, "거미");
INSERT INTO puser(hashcode, email, password, name, question_id, answer)
values(RAND_HASH(), "bug@abc.com", "4444", "Bug", 4, "버그");
INSERT INTO puser(hashcode, email, password, name, question_id, answer)
values(RAND_HASH(), "cs@abc.com", "5555", "ComputerScience", 4, "컴퓨터과학");

INSERT INTO pfeed (hashcode, content)
SELECT hashcode, 
'우리 웹사이트에 친구찾기 및 추가 기능이 새로 생겼습니다. 많이 이용해주시길 바랍니다!' 
FROM puser WHERE email = 'banana@abc.com';

INSERT INTO pfeed (hashcode, content)
SELECT hashcode, 
'안녕하세요. 개발진입니다. 사용자의 편의를 도모하기 위해 기존 서비스하던 파일업로드 페이지가 삭제될 예정입니다.
 넓은 양해 부탁드립니다 감사합니다.' 
FROM puser WHERE email = 'melon@abc.com';

INSERT INTO pfeed (hashcode, content)
SELECT hashcode, 
'알립니다! 기존 모든 유저들을 조회할 수 있던 시스템이 제거되고 마이페이지에 유저 검색 기능이 통합될 예정입니다.' 
FROM puser WHERE email = 'spider@abc.com';

INSERT INTO pfeed (hashcode, content)
SELECT hashcode, 
'안녕하십니까! 조선대학교 컴퓨터공학과 홍보팀 김코딩입니다! 
어느덧 봄이 지나고 여름이 다가오고 있습니다. 일교차가 한창 심할때이니 옷차림에 각별히 주의해주시길 바랍니다. 
저희 조선대 컴퓨터공학과에서는 이달 20일 ✨긴식행사✨를 진행할 예정입니다! 
컴퓨터공학과 학생이라면 누구든지 7층 중앙현관에서 받아가실 수 있습니다. 많은 참여 부탁드립니다 감사합니다!'
FROM puser WHERE email = 'bug@abc.com';

INSERT INTO pfeed (hashcode, content)
SELECT hashcode, 
'[컴퓨터공학과에서 알립니다]<br><br>교내 장학생 선발을 위한 교내특별토익시험을 이달 27일 시행할 예정입니다.
응시를 희망하시는 학우분들께서는 1층 교학팀에 방문하셔서 신청 서류를 받아가시길 바랍니다.' 
FROM puser WHERE email = 'cs@abc.com';



