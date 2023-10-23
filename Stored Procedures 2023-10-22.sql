

-- Tabela Professor
CREATE TABLE Professor (
    ProfessorID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50),
    Sobrenome VARCHAR(50),
    Email VARCHAR(100)
);

-- Tabela Curso
CREATE TABLE Curso (
    CursoID INT PRIMARY KEY AUTO_INCREMENT,
    NomeCurso VARCHAR(100),
    Departamento VARCHAR(50),
    ProfessorID INT,
    FOREIGN KEY (ProfessorID) REFERENCES Professor(ProfessorID)
);

-- Tabela Aluno
CREATE TABLE Aluno (
    AlunoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50),
    Sobrenome VARCHAR(50),
    DataNascimento DATE,
    Email VARCHAR(100),
    CursoID INT,
    FOREIGN KEY (CursoID) REFERENCES Curso(CursoID)
);

-- Inserção de Professores
INSERT INTO Professor (Nome, Sobrenome, Email) VALUES ('João', 'Silva', 'joao.silva@dominio.com');
INSERT INTO Professor (Nome, Sobrenome, Email) VALUES ('Maria', 'Fernandes', 'maria.fernandes@dominio.com');

-- Inserção de Cursos
INSERT INTO Curso (NomeCurso, Departamento, ProfessorID) VALUES ('Matemática 101', 'Matemática', 1);
INSERT INTO Curso (NomeCurso, Departamento, ProfessorID) VALUES ('História Antiga', 'História', 2);

-- Procedimento para inserir alunos com geração automática de e-mail
DELIMITER $

CREATE PROCEDURE InserirAluno(
    IN NomeAluno VARCHAR(50),
    IN SobrenomeAluno VARCHAR(50),
    IN DataNascimento DATE,
    IN CursoID INT
)
BEGIN
    DECLARE EmailAluno VARCHAR(100);
    DECLARE EmailSuffix INT;
    DECLARE EmailExists INT;
    
    SET EmailAluno = CONCAT(NomeAluno, '.', SobrenomeAluno, '@dominio.com');
    
    SELECT COUNT(*) INTO EmailExists FROM Aluno WHERE Email = EmailAluno;
    
    IF EmailExists > 0 THEN
        SET EmailSuffix = 1;
        
        WHILE EmailExists > 0 DO
            SET EmailAluno = CONCAT(NomeAluno, '.', SobrenomeAluno, '.', EmailSuffix, '@dominio.com');
            SELECT COUNT(*) INTO EmailExists FROM Aluno WHERE Email = EmailAluno;
            SET EmailSuffix = EmailSuffix + 1;
        END WHILE;
    END IF;
    
    INSERT INTO Aluno (Nome, Sobrenome, DataNascimento, Email, CursoID) VALUES (NomeAluno, SobrenomeAluno, DataNascimento, EmailAluno, CursoID);
END;
$

DELIMITER ;


-- Inserção de alunos com chamadas ao procedimento InserirAluno
CALL InserirAluno('Ana', 'Oliveira', '2000-01-15', 1);
CALL InserirAluno('Pedro', 'Santos', '1999-05-20', 2);

-- Consulta para verificar os dados dos alunos
SELECT * FROM Aluno;
