/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 01-Compet-CreerEnv.sql      Auteur : Ch. Stettler
Objet  : Création et remplissage des tables du cas Competition
---------------------------------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';  -- défini le format des dates

-- suppression des tables
ALTER TABLE heg_club DROP COLUMN clu_per_no;
DROP TABLE heg_participe;
DROP TABLE heg_competition;
DROP TABLE heg_personne;
DROP TABLE heg_club;

-- création des tables de base
CREATE TABLE heg_club (
                          clu_no      NUMBER(5)    CONSTRAINT pk_heg_club PRIMARY KEY,
                          clu_nom     VARCHAR2(20) CONSTRAINT uk_clu_nom UNIQUE CONSTRAINT nn_clu_nom NOT NULL,
                          clu_email   VARCHAR2(20),
                          clu_ville   VARCHAR2(20)
);

CREATE TABLE heg_personne (
                              per_no      NUMBER(5)    CONSTRAINT pk_heg_personne PRIMARY KEY,
                              per_nom     VARCHAR2(20) CONSTRAINT nn_per_nom NOT NULL,
                              per_prenom  VARCHAR2(20),
                              per_sexe    VARCHAR2(1)  CONSTRAINT ch_per_sexe CHECK (per_sexe IN ('M', 'F')),
                              per_email   VARCHAR2(20),
                              per_ville   VARCHAR2(20),
                              per_clu_no  NUMBER(5)    CONSTRAINT fk_heg_personne_club REFERENCES heg_club (clu_no),
                              CONSTRAINT uk_per_nom_prenom UNIQUE(per_nom, per_prenom)
);

ALTER TABLE heg_club ADD clu_per_no NUMBER(5) CONSTRAINT fk_heg_club_personne REFERENCES heg_personne (per_no);

CREATE TABLE heg_competition (
                                 com_no      NUMBER(5)    CONSTRAINT pk_heg_competition PRIMARY KEY,
                                 com_nom     VARCHAR2(20) CONSTRAINT nn_com_nom_compet  NOT NULL,
                                 com_date    DATE,
                                 com_lieu    VARCHAR2(20),
                                 com_ville   VARCHAR2(20) DEFAULT 'Genève',
                                 com_prix    NUMBER(3)    CONSTRAINT ch_com_prix CHECK (com_prix >= 0),
                                 com_clu_no  NUMBER(5)    CONSTRAINT fk_heg_competition_club REFERENCES heg_club (clu_no) CONSTRAINT nn_com_clu_no NOT NULL,
                                 CONSTRAINT uk_com_nom_date_lieu_ville UNIQUE (com_nom, com_date, com_lieu, com_ville)
);

CREATE TABLE heg_participe (
                               par_per_no  NUMBER(5)    CONSTRAINT fk_heg_participe_personne    REFERENCES heg_personne (per_no),
                               par_com_no  NUMBER(5)    CONSTRAINT fk_heg_participe_competition REFERENCES heg_competition (com_no),
                               CONSTRAINT pk_heg_participe PRIMARY KEY (par_per_no, par_com_no)
);

-- insertion des données initiales
INSERT INTO heg_club VALUES (1, 'HEG-Running',         'running@heg.ch', 'Carouge',  NULL);
INSERT INTO heg_club VALUES (2, 'Football Club 62-31', 'fc6231@heg.ch',  'Genève',   NULL);
INSERT INTO heg_club VALUES (3, 'Traînes-Savates BDD', 'ts.bdd@heg.ch',  'Lausanne', NULL);
INSERT INTO heg_club VALUES (4, 'HEG-SwimmingClub',    'swimm@heg.ch',   'genève',   NULL);
INSERT INTO heg_club VALUES (5, 'HEG-PédaleClub',      'velo@heg.ch',    'Genève',   NULL);
INSERT INTO heg_club VALUES (6, 'Aviron Club HEG',     'aviron@heg.ch',  'Lausanne', NULL);

INSERT INTO heg_personne VALUES ( 1, 'Bon',        'Jean',      'M', 'bj@heg.ch', 'Genève', 3);
INSERT INTO heg_personne VALUES ( 2, 'Remord',     'Yves',      'M', 'ry@heg.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES ( 3, 'Terieur',    'Alex',      'M', 'ta@hes.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES ( 4, 'Proviste',   'Alain',     'M', 'pa@eig.ch', 'Genève', NULL);
INSERT INTO heg_personne VALUES ( 5, 'Terieur',    'Alain',     'M', 'ti@heg.ch', 'Genève', NULL);
INSERT INTO heg_personne VALUES ( 6, 'Dissoire',   'Sam',       'M',  NULL,       'genève', 2);
INSERT INTO heg_personne VALUES ( 7, 'Dorsa',      'Elsa',      'F', 'de@hem.ch', 'Genève', 4);
INSERT INTO heg_personne VALUES ( 8, 'Posteur',    'alain',     'M', 'pa@hes.ch', 'Genève', 2);
INSERT INTO heg_personne VALUES ( 9, 'Onyme',      'Anne',      'F', 'oa@hes.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES (10, 'Vanbus',     'Hillary',   'F', 'vh@heg.ch', 'Carouge', NULL);
INSERT INTO heg_personne VALUES (11, 'Carre',      'Otto',      'M', 'co@heg.ch',  NULL, 4);
INSERT INTO heg_personne VALUES (12, 'Vaisselle',  'Aude',      'F', 'va@hem.ch', 'Carouge', 6);
INSERT INTO heg_personne VALUES (13, 'Hochon',     'Paul',      'M', 'hp@eig.ch', 'genève', 3);
INSERT INTO heg_personne VALUES (14, 'Route',      'Otto',      'M', 'ro@heg.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES (15, 'Honnete',    'Camille',   'F',  NULL,       'Lausanne', 1);
INSERT INTO heg_personne VALUES (16, 'Desie',      'Géo',       'M', 'dg@HEG.ch', 'Genève', 2);
INSERT INTO heg_personne VALUES (17, 'Logie',      'Géo',       'M', 'lg@heg.ch', 'Lausanne', 1);
INSERT INTO heg_personne VALUES (18, 'Aiterie',    'Marc',      'M', 'am@eig.ch', 'Genève', 3);
INSERT INTO heg_personne VALUES (19, 'Hemick',     'Paul',      'M',  NULL,       'Genève', NULL);
INSERT INTO heg_personne VALUES (20, 'Ofraise',    'Charlotte', 'F', 'oc@heg.ch', 'Genève', 3);
INSERT INTO heg_personne VALUES (21, 'Suffi',      'Sam',       'M', 'ss@heg.ch',  NULL, 4);
INSERT INTO heg_personne VALUES (22, 'Graphe',     'géo',       'M', 'gg@Heg.ch', 'Lausanne', 1);
INSERT INTO heg_personne VALUES (23, 'Tron',       'Paul',      'M', 'pt@heg.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES (24, 'Graphie',    'Géo',       'M', 'gg@hes.ch', 'Lausanne', 3);
INSERT INTO heg_personne VALUES (25, 'Sue',        'Alain',     'M', 'sa@HEM.ch', 'Genève', 2);
INSERT INTO heg_personne VALUES (26, 'Position',   'paul',      'M',  NULL,       'Lausanne', 3);
INSERT INTO heg_personne VALUES (27, 'Metre',      'géo',       'M', 'mg@heg.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES (28, 'De Lune',    'Claire',    'F', 'dc@Hes.ch', 'Nyon', 3);
INSERT INTO heg_personne VALUES (29, 'Hitmieux',   'Elmer',     'M', 'he@heg.ch', 'Genève', 2);
INSERT INTO heg_personne VALUES (30, 'Ition',      'Aude',      'F', 'ia@Hem.ch', 'Genève', 1);
INSERT INTO heg_personne VALUES (31, 'Tim',        'Vincent',   'M', 'tv@heg.ch', 'Genève', 3);
INSERT INTO heg_personne VALUES (32, 'Atan',       'Charles',   'M', 'ac@eig.ch', 'Lausanne', 1);

-- indication des présidents de club
UPDATE heg_club SET clu_per_no =  3 WHERE clu_no = 1;
UPDATE heg_club SET clu_per_no = 13 WHERE clu_no = 3;
UPDATE heg_club SET clu_per_no = 11 WHERE clu_no = 4;
UPDATE heg_club SET clu_per_no =  3 WHERE clu_no = 5;

INSERT INTO heg_competition VALUES (1, 'Course diplômésHEG', '20.06.2023', 'Battelle', 'Carouge',      25, 1);
INSERT INTO heg_competition VALUES (2, 'Tour du Campus',     '26.03.2024', 'Battelle', 'Carouge',      10, 1);
INSERT INTO heg_competition VALUES (3, 'TouDouMollo-Run',    '31.10.2024', 'Bout-du-monde', DEFAULT,   30, 3);
INSERT INTO heg_competition VALUES (4, 'HEG-TraverséeDuLac', '11.06.2024', 'Vidy',     'Lausanne',     50, 4);
INSERT INTO heg_competition VALUES (5, 'Tour du Campus',     '19.08.2024', 'Battelle', 'Carouge',      10, 5);
INSERT INTO heg_competition VALUES (6, 'Course diplômésHEG', '25.06.2024', 'Battelle', 'Carouge',      30, 1);
INSERT INTO heg_competition VALUES (7, 'Course diplômésHEG', '25.06.2024', 'Beaulieu', 'Lausanne',     35, 6);
INSERT INTO heg_competition VALUES (8, 'Triathlon HEG',      '06.08.2024', 'Bains des Pâquis',DEFAULT, 40, 4);
INSERT INTO heg_competition VALUES (9, 'TouDouMollo-Run',    '21.01.2025', 'Bout-du-monde',   DEFAULT, 35, 3);
INSERT INTO heg_competition VALUES (10,'Tour du Campus',     '24.06.2025', 'Battelle', 'Carouge',      NULL, 1);

INSERT INTO heg_participe VALUES ( 1, 1);
INSERT INTO heg_participe VALUES ( 2, 1);
INSERT INTO heg_participe VALUES ( 3, 1);
INSERT INTO heg_participe VALUES ( 6, 1);
INSERT INTO heg_participe VALUES ( 7, 1);
INSERT INTO heg_participe VALUES ( 9, 1);
INSERT INTO heg_participe VALUES (11, 1);
INSERT INTO heg_participe VALUES (13, 1);
INSERT INTO heg_participe VALUES (15, 1);
INSERT INTO heg_participe VALUES (18, 1);
INSERT INTO heg_participe VALUES (25, 1);
INSERT INTO heg_participe VALUES (26, 1);
INSERT INTO heg_participe VALUES (27, 1);
INSERT INTO heg_participe VALUES (29, 1);
INSERT INTO heg_participe VALUES (30, 1);
INSERT INTO heg_participe VALUES ( 1, 2);
INSERT INTO heg_participe VALUES ( 5, 2);
INSERT INTO heg_participe VALUES ( 6, 2);
INSERT INTO heg_participe VALUES (11, 2);
INSERT INTO heg_participe VALUES (15, 2);
INSERT INTO heg_participe VALUES (17, 2);
INSERT INTO heg_participe VALUES (18, 2);
INSERT INTO heg_participe VALUES (25, 2);
INSERT INTO heg_participe VALUES (27, 2);
INSERT INTO heg_participe VALUES (28, 2);
INSERT INTO heg_participe VALUES (29, 2);
INSERT INTO heg_participe VALUES (30, 2);
INSERT INTO heg_participe VALUES (31, 2);
INSERT INTO heg_participe VALUES (32, 2);
INSERT INTO heg_participe VALUES ( 2, 3);
INSERT INTO heg_participe VALUES ( 6, 3);
INSERT INTO heg_participe VALUES ( 9, 3);
INSERT INTO heg_participe VALUES (11, 3);
INSERT INTO heg_participe VALUES (15, 3);
INSERT INTO heg_participe VALUES (16, 3);
INSERT INTO heg_participe VALUES (17, 3);
INSERT INTO heg_participe VALUES (18, 3);
INSERT INTO heg_participe VALUES (23, 3);
INSERT INTO heg_participe VALUES (26, 3);
INSERT INTO heg_participe VALUES (27, 3);
INSERT INTO heg_participe VALUES (28, 3);
INSERT INTO heg_participe VALUES (29, 3);
INSERT INTO heg_participe VALUES (30, 3);
INSERT INTO heg_participe VALUES (31, 3);
INSERT INTO heg_participe VALUES (32, 3);
INSERT INTO heg_participe VALUES ( 2, 5);
INSERT INTO heg_participe VALUES ( 3, 5);
INSERT INTO heg_participe VALUES ( 4, 5);
INSERT INTO heg_participe VALUES ( 5, 5);
INSERT INTO heg_participe VALUES ( 6, 5);
INSERT INTO heg_participe VALUES ( 7, 5);
INSERT INTO heg_participe VALUES ( 8, 5);
INSERT INTO heg_participe VALUES (10, 5);
INSERT INTO heg_participe VALUES (11, 5);
INSERT INTO heg_participe VALUES (27, 5);
INSERT INTO heg_participe VALUES ( 4, 6);
INSERT INTO heg_participe VALUES ( 5, 6);
INSERT INTO heg_participe VALUES ( 6, 6);
INSERT INTO heg_participe VALUES ( 8, 6);
INSERT INTO heg_participe VALUES (11, 6);
INSERT INTO heg_participe VALUES (12, 6);
INSERT INTO heg_participe VALUES (13, 6);
INSERT INTO heg_participe VALUES (14, 6);
INSERT INTO heg_participe VALUES (25, 6);
INSERT INTO heg_participe VALUES (26, 6);
INSERT INTO heg_participe VALUES (27, 6);
INSERT INTO heg_participe VALUES ( 6, 7);
INSERT INTO heg_participe VALUES (10, 9);
INSERT INTO heg_participe VALUES (20, 9);
INSERT INTO heg_participe VALUES (30, 9);
COMMIT;
