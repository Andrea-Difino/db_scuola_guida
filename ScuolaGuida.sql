CREATE TABLE Citta (
    CodiceCatastale CHAR(4) PRIMARY KEY,
    NomeCitta VARCHAR(30) NOT NULL,
    CAP VARCHAR(5) NOT NULL,
    Provincia VARCHAR(2) NOT NULL
);

CREATE TABLE Iscritto (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    DataIscrizione DATE NOT NULL,
    TipoPatente TEXT CHECK(TipoPatente IN
    (
        'A', 'A1', 'A2', 'AM', 'B', 'B1', 'BE', 'B96',
        'C', 'C1', 'CE', 'C1E', 'D', 'D1', 'DE', 'D1E', 'M'
    )) NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Indirizzo VARCHAR(20) NOT NULL,
    Email VARCHAR(25) UNIQUE NOT NULL,
    Numero VARCHAR(25) UNIQUE NOT NULL,
    IDCitta CHAR(4) NOT NULL,
    FOREIGN KEY (IDCitta) REFERENCES Citta(CodiceCatastale)
);

CREATE TABLE Veicolo (
    Targa CHAR(7) PRIMARY KEY,
    Modello VARCHAR(30),
    AnnoImmatricolazione INTEGER CHECK (AnnoImmatricolazione BETWEEN 1980 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    Stato TEXT CHECK(Stato IN ('Disponibile', 'In Manutenzione', 'Non Disponibile')),
    TipoVeicolo TEXT CHECK(TipoVeicolo IN ('Auto', 'Moto', 'Camion'))
);

CREATE TABLE Aula (
    NomeAula VARCHAR(20) PRIMARY KEY,
    Posti INTEGER NOT NULL,
    Attrezzatura TEXT CHECK(Attrezzatura IN ('Proiettore', 'Lavagna', 'LIM', 'Impianto Audio')) NOT NULL
);

CREATE TABLE Istruttore (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    AnniEsperienza INTEGER NOT NULL,
    Numero VARCHAR(12) UNIQUE NOT NULL,
    Email VARCHAR (30) UNIQUE NOT NULL
);

CREATE TABLE Esame (
    Data DATE,
    CodiceFiscale CHAR(16),
    TipoEsame TEXT CHECK(TipoEsame IN ('Teorico', 'Pratico')) NOT NULL,
    Durata INTEGER NOT NULL,
    Esito BOOLEAN NOT NULL,
    Sede VARCHAR(30),
    Punti INTEGER,
    PRIMARY KEY (Data, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Partecipazione (
    CodiceFiscale CHAR(16),
    Data DATE,
    PRIMARY KEY (CodiceFiscale, Data),
    FOREIGN KEY (CodiceFiscale, Data) REFERENCES Esame(CodiceFiscale, Data)
);

CREATE TABLE Lezione (
    Data DATE,
    ArgomentoLezione VARCHAR(25),
    TipoLezione TEXT CHECK(TipoLezione IN ('Teorico', 'Pratico')),
    OraInizio TIME NOT NULL,
    CFIstruttore CHAR(16) NOT NULL,
    Durata INTEGER,
    IDAula VARCHAR(20), 
    VeicoloUsato CHAR(7),
    PRIMARY KEY (Data, ArgomentoLezione),
    FOREIGN KEY (CFIstruttore) REFERENCES Istruttore(CodiceFiscale),
    FOREIGN KEY (IDAula) REFERENCES Aula(NomeAula),
    FOREIGN KEY (VeicoloUsato) REFERENCES Veicolo(Targa)
);

CREATE TABLE Recensione (
    CodiceFiscale CHAR(16) NOT NULL,
    Oggetto VARCHAR(50) NOT NULL,
    Commento TEXT NOT NULL,
    Email VARCHAR(30) NOT NULL,
    Data DATE NOT NULL,
    Gradimento INTEGER CHECK(Gradimento BETWEEN 1 AND 5) NOT NULL,
    CFIstruttore CHAR(16),
    DataLezione DATE, 
    ArgomentoLezione VARCHAR(30),
    PRIMARY KEY (CodiceFiscale, Oggetto),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale),
    FOREIGN KEY (CFIstruttore) REFERENCES Istruttore(CodiceFiscale),
    FOREIGN KEY (DataLezione, ArgomentoLezione) REFERENCES Lezione(Data, ArgomentoLezione)
);



CREATE TABLE Prenotazione (
    DataPrenotazione DATE,
    CodiceFiscale CHAR(16),
    Ora TIME,
    Stato TEXT CHECK(Stato IN ('Accettata', 'Rifiutata', 'In attesa')),
    DataLezione DATE,
    ArgomentoLezione VARCHAR(30) NOT NULL,
    PRIMARY KEY (DataPrenotazione, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale),
    FOREIGN KEY (DataLezione, ArgomentoLezione) REFERENCES Lezione(Data, ArgomentoLezione)
);

CREATE TABLE Pagamento (
    Importo DECIMAL(10, 2),
    Data DATE,
    OraPagamento TIME,
    CodiceFiscale CHAR(16),
    Stato TEXT CHECK(Stato IN ('Accettata', 'Rifiutata', 'In attesa')),
    MetodoPagamento TEXT CHECK(MetodoPagamento IN ('carta', 'contanti', 'bonifico')),
    PRIMARY KEY (Data, OraPagamento, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Patente (
    TipoPatente TEXT PRIMARY KEY CHECK (TipoPatente IN (
        'A', 'A1', 'A2', 'AM', 'B', 'B1', 'BE', 'B96',
        'C', 'C1', 'CE', 'C1E', 'D', 'D1', 'DE', 'D1E', 'M'
    )) NOT NULL,
    Descrizione TEXT NOT NULL
);

CREATE TABLE Abilitazione (
    IstruttoreCF CHAR(16) NOT NULL,
    TipoPatente TEXT NOT NULL,
    PRIMARY KEY (IstruttoreCF, TipoPatente),
    FOREIGN KEY (IstruttoreCF) REFERENCES Istruttore(CodiceFiscale),
    FOREIGN KEY (TipoPatente) REFERENCES Patente(TipoPatente)
);

INSERT INTO Citta (CodiceCatastale, NomeCitta, CAP, Provincia) VALUES
('H501', 'Roma', '00100', 'RM'),
('F205', 'Milano', '20100', 'MI'),
('A944', 'Bologna', '40100', 'BO'),
('F839', 'Napoli', '80100', 'NA'),
('L219', 'Torino', '10100', 'TO'),
('D612', 'Firenze', '50100', 'FI'),
('A662', 'Bari', '70100', 'BA'),
('C351', 'Catania', '95100', 'CT'),
('G273', 'Palermo', '90100', 'PA'),
('L781', 'Venezia', '30100', 'VE'),
('H294', 'Rimini', '47900', 'RN'),
('E463', 'Latina', '04100', 'LT'),
('G337', 'Parma', '43100', 'PR'),
('G702', 'Pisa', '56100', 'PI'),
('I726', 'Siena', '53100', 'SI'),
('F704', 'Modena', '41100', 'MO'),
('A952', 'Bolzano', '39100', 'BZ'),
('L378', 'Trento', '38100', 'TN'),
('H163', 'Ravenna', '48100', 'RA'),
('D548', 'Ferrara', '44100', 'FE');

INSERT INTO Iscritto (CodiceFiscale, DataIscrizione, TipoPatente, Nome, Cognome, Indirizzo, Email, Numero, IDCitta) VALUES
('RSSMRA80A01H501A', '2025-01-01', 'B', 'Mario', 'Rossi', 'Via Roma 1', 'mario.rossi@email.it', '3331234567', 'H501'),
('VRDLCA81B02H501B', '2025-01-02', 'A', 'Luca', 'Verdi', 'Via Milano 2', 'luca.verdi@email.it', '3331234568', 'F205'),
('BNCGPP82C03H501C', '2025-01-03', 'C', 'Giuseppe', 'Bianchi', 'Via Napoli 3', 'giuseppe.b@email.it', '3331234569', 'F839'),
('NRENNA83D04H501D', '2025-01-04', 'B', 'Anna', 'Neri', 'Via Torino 4', 'anna.neri@email.it', '3331234570', 'L219'),
('GLLMRC84E05H501E', '2025-01-05', 'A1', 'Marco', 'Gialli', 'Via Palermo 5', 'marco.g@email.it', '3331234571', 'G273'),
('VLNSFN85F06H501F', '2025-01-06', 'B', 'Stefano', 'Viola', 'Via Genova 6', 'stefano.v@email.it', '3331234572', 'F205'),
('RSSMRA86G07H501G', '2025-01-07', 'C1', 'Maria', 'Russo', 'Via Firenze 7', 'maria.r@email.it', '3331234573', 'D612'),
('CNTLCA87H08H501H', '2025-01-08', 'B', 'Luca', 'Conti', 'Via Bologna 8', 'luca.c@email.it', '3331234574', 'A944'),
('FRRPLA88I09H501I', '2025-01-09', 'A2', 'Paola', 'Ferrari', 'Via Venezia 9', 'paola.f@email.it', '3331234575', 'L781'),
('MRTGNN89L10H501L', '2025-01-10', 'B', 'Gianna', 'Moretti', 'Via Bari 10', 'gianna.m@email.it', '3331234576', 'A662'),
('BRNGPP90M11H501M', '2025-01-11', 'B', 'Giuseppe', 'Bruni', 'Via Catania 11', 'giuseppe@email.it', '3331234577', 'C351'),
('RMNNNA91N12H501N', '2025-01-12', 'A', 'Anna', 'Romano', 'Via Verona 12', 'anna.rom@email.it', '3331234578', 'F205'),
('GLLCRL92P13H501P', '2025-01-13', 'B', 'Carlo', 'Galli', 'Via Messina 13', 'carlo.g@email.it', '3331234579', 'F205'), 
('RSSLRA93Q14H501Q', '2025-01-14', 'C', 'Laura', 'Rossi', 'Via Padova 14', 'laura.r@email.it', '3331234580', 'F205'),
('BNCFBA94R15H501R', '2025-01-15', 'B', 'Fabio', 'Bianchi', 'Via Trieste 15', 'fabio.b@email.it', '3331234581', 'F205'), 
('VLNLSA95S16H501S', '2025-01-16', 'A1', 'Elisa', 'Viola', 'Via Rimini 16', 'elisa.v@email.it', '3331234582', 'H294'),
('RSSMTA96T17H501T', '2025-01-17', 'B', 'Marta', 'Rossi', 'Via Parma 17', 'marta.r@email.it', '3331234583', 'G337'),
('CNTDVD97U18H501U', '2025-01-18', 'B', 'Davide', 'Conti', 'Via Pisa 18', 'davide.c@email.it', '3331234584', 'G702'),
('FRRSRA98V19H501V', '2025-01-19', 'A2', 'Sara', 'Ferrari', 'Via Latina 19', 'sara.f@email.it', '3331234585', 'E463'),
('MTTPLA99Z20H501Z', '2025-01-20', 'B', 'Paolo', 'Motti', 'Via Siena 20', 'paolo.m@email.it', '3331234586', 'I726');


INSERT INTO Esame (Data, CodiceFiscale, TipoEsame, Durata, Esito, Sede, Punti) VALUES
('2025-02-01', 'RSSMRA80A01H501A', 'Teorico', 60, TRUE, 'Sede Roma Centro', 28),
('2025-02-02', 'VRDLCA81B02H501B', 'Pratico', 45, TRUE, NULL, NULL),
('2025-02-03', 'BNCGPP82C03H501C', 'Teorico', 60, FALSE, 'Sede Roma Centro', 15),
('2025-02-04', 'NRENNA83D04H501D', 'Pratico', 45, TRUE, NULL, NULL),
('2025-02-05', 'GLLMRC84E05H501E', 'Teorico', 60, TRUE, 'Sede Roma Est', 25),
('2025-02-06', 'VLNSFN85F06H501F', 'Pratico', 45, FALSE, NULL, NULL),
('2025-02-07', 'RSSMRA86G07H501G', 'Teorico', 60, TRUE, 'Sede Roma Centro', 30),
('2025-02-08', 'CNTLCA87H08H501H', 'Pratico', 45, TRUE, NULL, NULL),
('2025-02-09', 'FRRPLA88I09H501I', 'Teorico', 60, TRUE, 'Sede Roma Centro', 27),
('2025-02-10', 'MRTGNN89L10H501L', 'Pratico', 45, FALSE, NULL, NULL),
('2025-02-11', 'BRNGPP90M11H501M', 'Teorico', 60, TRUE, 'Sede Roma Est', 29),
('2025-02-12', 'RMNNNA91N12H501N', 'Pratico', 45, TRUE, NULL, NULL),
('2025-02-13', 'GLLCRL92P13H501P', 'Teorico', 60, FALSE, 'Sede Roma Centro', 18),
('2025-02-14', 'RSSLRA93Q14H501Q', 'Pratico', 45, TRUE, NULL, NULL),
('2025-02-15', 'BNCFBA94R15H501R', 'Teorico', 60, TRUE, 'Sede Roma Centro', 26),
('2025-02-16', 'VLNLSA95S16H501S', 'Pratico', 45, TRUE, NULL, NULL),
('2025-02-17', 'RSSMTA96T17H501T', 'Teorico', 60, TRUE, 'Sede Roma Est', 24),
('2025-02-18', 'CNTDVD97U18H501U', 'Pratico', 45, FALSE, NULL, NULL),
('2025-02-19', 'FRRSRA98V19H501V', 'Teorico', 60, TRUE, 'Sede Roma Centro', 28),
('2025-02-20', 'MTTPLA99Z20H501Z', 'Pratico', 45, TRUE, NULL, NULL);


INSERT INTO Partecipazione (CodiceFiscale, Data) VALUES
('RSSMRA80A01H501A', '2025-02-01'),
('VRDLCA81B02H501B', '2025-02-02'),
('BNCGPP82C03H501C', '2025-02-03'),
('NRENNA83D04H501D', '2025-02-04'),
('GLLMRC84E05H501E', '2025-02-05'),
('VLNSFN85F06H501F', '2025-02-06'),
('RSSMRA86G07H501G', '2025-02-07'),
('CNTLCA87H08H501H', '2025-02-08'),
('FRRPLA88I09H501I', '2025-02-09'),
('MRTGNN89L10H501L', '2025-02-10'),
('BRNGPP90M11H501M', '2025-02-11'),
('RMNNNA91N12H501N', '2025-02-12'),
('GLLCRL92P13H501P', '2025-02-13'),
('RSSLRA93Q14H501Q', '2025-02-14'),
('BNCFBA94R15H501R', '2025-02-15'),
('VLNLSA95S16H501S', '2025-02-16'),
('RSSMTA96T17H501T', '2025-02-17'),
('CNTDVD97U18H501U', '2025-02-18'),
('FRRSRA98V19H501V', '2025-02-19'),
('MTTPLA99Z20H501Z', '2025-02-20');

INSERT INTO Istruttore (CodiceFiscale, Nome, Cognome, AnniEsperienza, Numero, Email) VALUES
('BNCMRA70A01H501X', 'Mario', 'Bianchi', 15, '321234567890', 'mario.bianchi@scuola.it'),
('RSSGVN75B02H501Y', 'Giovanni', 'Rossi', 12, '322234567890', 'giovanni.rossi@scuola.it'),
('VRDLCA80C03H501Z', 'Luca', 'Verdi', 10, '323234567890', 'luca.verdi@scuola.it'),
('NRIGPP85D04H501W', 'Giuseppe', 'Neri', 8, '324234567890', 'giuseppe.neri@scuola.it'),
('BNCNNA90E05H501V', 'Anna', 'Bianchi', 7, '325234567890', 'anna.bianchi@scuola.it'),
('RSSMRA75F06H501U', 'Maria', 'Rossi', 13, '326234567890', 'maria.rossi@scuola.it'),
('VRDPLA80G07H501T', 'Paolo', 'Verdi', 11, '327234567890', 'paolo.verdi@scuola.it'),
('NRILCU85H08H501S', 'Lucia', 'Neri', 9, '328234567890', 'lucia.neri@scuola.it'),
('BNCFBA90I09H501R', 'Fabio', 'Bianchi', 6, '329234567890', 'fabio.bianchi@scuola.it'),
('RSSSFN75L10H501Q', 'Stefano', 'Rossi', 14, '330234567890', 'stefano.rossi@scuola.it'),
('VRDMRC80M11H501P', 'Marco', 'Verdi', 12, '331234567890', 'marco.verdi@scuola.it');

INSERT INTO Aula (NomeAula, Posti, Attrezzatura) VALUES
('Aula Magna', 100, 'Proiettore'),
('Aula 1A', 30, 'LIM'),
('Aula 1B', 25, 'Lavagna'),
('Aula 2A', 40, 'Proiettore'),
('Aula 2B', 35, 'Impianto Audio'),
('Aula 3A', 45, 'LIM'),
('Aula 3B', 20, 'Lavagna'),
('Aula 4A', 50, 'Proiettore'),
('Aula 4B', 30, 'Impianto Audio'),
('Aula 5A', 35, 'LIM'),
('Aula 5B', 25, 'Lavagna'),
('Aula 6A', 40, 'Proiettore'),
('Aula 6B', 30, 'Impianto Audio'),
('Aula 7A', 45, 'LIM'),
('Aula 7B', 20, 'Lavagna'),
('Aula 8A', 50, 'Proiettore'),
('Aula 8B', 35, 'Impianto Audio'),
('Aula 9A', 30, 'LIM'),
('Aula 9B', 25, 'Lavagna'),
('Aula 10A', 40, 'Proiettore');

INSERT INTO Veicolo (Targa, Modello, AnnoImmatricolazione, Stato, TipoVeicolo) VALUES
('AA111BB', 'Fiat Panda', 2023, 'Disponibile', 'Auto'),
('BB222CC', 'Honda CBR', 2023, 'Disponibile', 'Moto'),
('CC333DD', 'Iveco Daily', 2022, 'In Manutenzione', 'Camion'),
('DD444EE', 'Toyota Yaris', 2023, 'Disponibile', 'Auto'),
('EE555FF', 'Yamaha R1', 2022, 'Non Disponibile', 'Moto'),
('FF666GG', 'Mercedes Actros', 2021, 'Disponibile', 'Camion'),
('GG777HH', 'Volkswagen Golf', 2023, 'Disponibile', 'Auto'),
('HH888II', 'Ducati Monster', 2023, 'Disponibile', 'Moto'),
('II999LL', 'Scania R450', 2022, 'In Manutenzione', 'Camion'),
('LL000MM', 'Ford Fiesta', 2023, 'Disponibile', 'Auto'),
('MM111NN', 'BMW S1000RR', 2022, 'Disponibile', 'Moto'),
('NN222PP', 'MAN TGX', 2021, 'Non Disponibile', 'Camion'),
('PP333QQ', 'Renault Clio', 2023, 'Disponibile', 'Auto'),
('QQ444RR', 'Kawasaki Ninja', 2023, 'Disponibile', 'Moto'),
('RR555SS', 'Volvo FH', 2022, 'Disponibile', 'Camion'),
('SS666TT', 'Opel Corsa', 2023, 'In Manutenzione', 'Auto'),
('TT777UU', 'KTM Duke', 2022, 'Disponibile', 'Moto'),
('UU888VV', 'DAF XF', 2021, 'Disponibile', 'Camion'),
('VV999ZZ', 'Peugeot 208', 2023, 'Non Disponibile', 'Auto'),
('ZZ000AA', 'Aprilia RSV4', 2023, 'Disponibile', 'Moto');

INSERT INTO Lezione (Data, ArgomentoLezione, TipoLezione, OraInizio, Durata, CFIstruttore, IDAula, VeicoloUsato) VALUES
('2025-04-01', 'Segnaletica stradale', 'Teorico', '09:00:00', NULL, 'BNCMRA70A01H501X', 'Aula Magna', NULL),
('2025-04-02', 'Precedenze', 'Teorico', '11:00:00', NULL, 'RSSGVN75B02H501Y', 'Aula 1A', NULL),
('2025-04-03', 'Parcheggio', 'Pratico', '14:00:00', 50, 'VRDLCA80C03H501Z', NULL, 'AA111BB'),
('2025-04-04', 'Codice della strada', 'Teorico', '09:00:00', NULL, 'NRIGPP85D04H501W', 'Aula 1B', NULL),
('2025-04-05', 'Guida in città', 'Pratico', '11:00:00', 60, 'BNCNNA90E05H501V', NULL, 'BB222CC'),
('2025-04-06', 'Sicurezza stradale', 'Teorico', '14:00:00', NULL, 'RSSMRA75F06H501U', 'Aula 2A', NULL),
('2025-04-07', 'Manovre base', 'Pratico', '09:00:00', 40, 'VRDPLA80G07H501T', NULL, 'DD444EE'),
('2025-04-08', 'Limiti di velocità', 'Teorico', '11:00:00', NULL, 'NRILCU85H08H501S', 'Aula 2B', NULL),
('2025-04-09', 'Guida notturna', 'Pratico', '14:00:00', 60, 'BNCFBA90I09H501R', NULL, 'FF666GG'),
('2025-04-10', 'Emergenze', 'Teorico', '09:00:00', NULL, 'RSSSFN75L10H501Q', 'Aula 3A', NULL),
('2025-04-11', 'Autostrada', 'Pratico', '11:00:00', 60, 'VRDMRC80M11H501P', NULL, 'GG777HH'),
('2025-04-12', 'Meccanica base', 'Teorico', '14:00:00', NULL, 'BNCMRA70A01H501X', 'Aula 3B', NULL),
('2025-04-13', 'Parcheggio parallelo', 'Pratico', '09:00:00', 80, 'RSSGVN75B02H501Y', NULL, 'HH888II'),
('2025-04-14', 'Primo soccorso', 'Teorico', '11:00:00', NULL, 'VRDLCA80C03H501Z', 'Aula 4A', NULL),
('2025-04-15', 'Guida eco', 'Pratico', '14:00:00', 60, 'NRIGPP85D04H501W', NULL, 'LL000MM'),
('2025-04-16', 'Meteo e guida', 'Teorico', '09:00:00', NULL, 'BNCNNA90E05H501V', 'Aula 4B', NULL),
('2025-04-17', 'Rotatorie', 'Pratico', '11:00:00', 50, 'RSSMRA75F06H501U', NULL, 'MM111NN'),
('2025-04-18', 'Documenti auto', 'Teorico', '14:00:00', NULL, 'VRDPLA80G07H501T', 'Aula 5A', NULL),
('2025-04-19', 'Guida sportiva', 'Pratico', '09:00:00', 30, 'NRILCU85H08H501S', NULL, 'PP333QQ'),
('2025-04-20', 'Manutenzione', 'Teorico', '11:00:00', NULL, 'BNCFBA90I09H501R', 'Aula 5B', NULL);

INSERT INTO Recensione (CodiceFiscale, Oggetto, Commento, Email, Data, Gradimento, CFIstruttore, DataLezione, ArgomentoLezione) VALUES
('RSSMRA80A01H501A', 'Ottimo corso', 'Istruttori molto preparati', 'mario.rossi@email.it', '2025-05-01', 5, 'BNCMRA70A01H501X', NULL, NULL),
('VRDLCA81B02H501B', 'Buona esperienza', 'Corso ben strutturato', 'luca.verdi@email.it', '2025-05-02', 4, NULL, '2025-04-02', 'Precedenze'), 
('BNCGPP82C03H501C', 'Soddisfatto', 'Ottimo rapporto qualità/prezzo', 'giuseppe.b@email.it', '2025-05-03', 5, NULL, '2025-04-03', 'Parcheggio'),
('NRENNA83D04H501D', 'Esperienza positiva', 'Personale disponibile', 'anna.neri@email.it', '2025-05-04', 4, 'NRIGPP85D04H501W', NULL, NULL),
('GLLMRC84E05H501E', 'Da migliorare', 'Orari poco flessibili', 'marco.g@email.it', '2025-05-05', 3, 'BNCNNA90E05H501V', NULL, NULL),
('VLNSFN85F06H501F', 'Molto professionale', 'Consigliato', 'stefano.v@email.it', '2025-05-06', 5, NULL, '2025-04-06', 'Sicurezza stradale'),
('RSSMRA86G07H501G', 'Corso eccellente', 'Ottima preparazione', 'maria.r@email.it', '2025-05-07', 5, 'VRDPLA80G07H501T', NULL, NULL),
('CNTLCA87H08H501H', 'Buon corso', 'Istruttori pazienti', 'luca.c@email.it', '2025-05-08', 4, 'NRILCU85H08H501S', NULL, NULL),
('FRRPLA88I09H501I', 'Esperienza ok', 'Corso nella media', 'paola.f@email.it', '2025-05-09', 3, NULL, '2025-04-09', 'Guida notturna'),
('MRTGNN89L10H501L', 'Molto soddisfatta', 'Ottima scuola', 'gianna.m@email.it', '2025-05-10', 5, NULL, '2025-04-10', 'Emergenze'),
('BRNGPP90M11H501M', 'Corso completo', 'Ben organizzato', 'giuseppe@email.it', '2025-05-11', 4, NULL, '2025-04-11', 'Autostrada'),
('RMNNNA91N12H501N', 'Esperienza positiva', 'Consigliato', 'anna.rom@email.it', '2025-05-12', 4, NULL, '2025-04-12', 'Meccanica base'),
('GLLCRL92P13H501P', 'Ottimo servizio', 'Personale competente', 'carlo.g@email.it', '2025-05-13', 5, 'VRDLCA80C03H501Z', NULL, NULL),
('RSSLRA93Q14H501Q', 'Corso efficace', 'Preparazione completa', 'laura.r@email.it', '2025-05-14', 4, 'NRIGPP85D04H501W', NULL, NULL),
('BNCFBA94R15H501R', 'Buona scuola', 'Ambiente professionale', 'fabio.b@email.it', '2025-05-15', 4, 'BNCNNA90E05H501V', NULL, NULL),
('VLNLSA95S16H501S', 'Esperienza positiva', 'Consigliata', 'elisa.v@email.it', '2025-05-16', 5, 'RSSMRA75F06H501U', NULL, NULL),
('RSSMTA96T17H501T', 'Corso valido', 'Ottimi istruttori', 'marta.r@email.it', '2025-05-17', 4, 'VRDPLA80G07H501T', NULL, NULL),
('CNTDVD97U18H501U', 'Soddisfatto', 'Buon rapporto qualità/prezzo', 'davide.c@email.it', '2025-05-18', 4, NULL, '2025-04-18', 'Documenti auto'),
('FRRSRA98V19H501V', 'Ottima scelta', 'Preparazione eccellente', 'sara.f@email.it', '2025-05-19', 5, NULL, '2025-04-19', 'Guida sportiva'),
('MTTPLA99Z20H501Z', 'Corso consigliato', 'Esperienza positiva', 'paolo.m@email.it', '2025-05-20', 4, NULL, '2025-04-20', 'Manutenzione');

INSERT INTO Prenotazione (DataPrenotazione, CodiceFiscale, Ora, Stato, DataLezione, ArgomentoLezione) VALUES
('2025-03-30', 'RSSMRA80A01H501A', '09:00:00', 'Accettata', '2025-04-01', 'Segnaletica stradale'),
('2025-03-31', 'VRDLCA81B02H501B', '10:00:00', 'In attesa', '2025-04-02', 'Precedenze'),
('2025-04-01', 'BNCGPP82C03H501C', '11:00:00', 'Accettata', '2025-04-03', 'Parcheggio'),
('2025-04-02', 'NRENNA83D04H501D', '14:00:00', 'Rifiutata', '2025-04-04', 'Codice della strada'),
('2025-04-03', 'GLLMRC84E05H501E', '15:00:00', 'Accettata', '2025-04-05', 'Guida in città'),
('2025-04-04', 'VLNSFN85F06H501F', '16:00:00', 'In attesa', '2025-04-06', 'Sicurezza stradale'),
('2025-04-05', 'RSSMRA86G07H501G', '09:00:00', 'Accettata', '2025-04-07', 'Manovre base'),
('2025-04-06', 'CNTLCA87H08H501H', '10:00:00', 'Accettata', '2025-04-08', 'Limiti di velocità'),
('2025-04-07', 'FRRPLA88I09H501I', '11:00:00', 'In attesa', '2025-04-09', 'Guida notturna'),
('2025-04-08', 'MRTGNN89L10H501L', '14:00:00', 'Rifiutata', '2025-04-10', 'Emergenze'),
('2025-04-09', 'BRNGPP90M11H501M', '15:00:00', 'Accettata', '2025-04-11', 'Autostrada'),
('2025-04-10', 'RMNNNA91N12H501N', '16:00:00', 'In attesa', '2025-04-12', 'Meccanica base'),
('2025-04-11', 'GLLCRL92P13H501P', '09:00:00', 'Accettata', '2025-04-13', 'Parcheggio parallelo'),
('2025-04-12', 'RSSLRA93Q14H501Q', '10:00:00', 'Accettata', '2025-04-14', 'Primo soccorso'),
('2025-04-13', 'BNCFBA94R15H501R', '11:00:00', 'In attesa', '2025-04-15', 'Guida eco'),
('2025-04-14', 'VLNLSA95S16H501S', '14:00:00', 'Rifiutata', '2025-04-16', 'Meteo e guida'),
('2025-04-15', 'RSSMTA96T17H501T', '15:00:00', 'Accettata', '2025-04-17', 'Rotatorie'),
('2025-04-16', 'CNTDVD97U18H501U', '16:00:00', 'In attesa', '2025-04-18', 'Documenti auto'),
('2025-04-17', 'FRRSRA98V19H501V', '09:00:00', 'Accettata', '2025-04-19', 'Guida sportiva'),
('2025-04-18', 'MTTPLA99Z20H501Z', '10:00:00', 'In attesa', '2025-04-20', 'Manutenzione');

INSERT INTO Pagamento (Importo, Data, OraPagamento, CodiceFiscale, Stato, MetodoPagamento) VALUES
(500.00, '2025-05-01', '09:00:00', 'RSSMRA80A01H501A', 'Accettata', 'carta'),
(600.00, '2025-05-02', '10:15:00', 'VRDLCA81B02H501B', 'In attesa', 'bonifico'),
(550.00, '2025-05-03', '11:30:00', 'BNCGPP82C03H501C', 'Accettata', 'contanti'),
(500.00, '2025-05-04', '09:45:00', 'NRENNA83D04H501D', 'Rifiutata', 'carta'),
(700.00, '2025-05-05', '14:00:00', 'GLLMRC84E05H501E', 'Accettata', 'bonifico'),
(600.00, '2025-05-06', '15:30:00', 'VLNSFN85F06H501F', 'In attesa', 'contanti'),
(550.00, '2025-05-07', '16:45:00', 'RSSMRA86G07H501G', 'Accettata', 'carta'),
(500.00, '2025-05-08', '17:15:00', 'CNTLCA87H08H501H', 'Accettata', 'bonifico'),
(700.00, '2025-05-09', '10:00:00', 'FRRPLA88I09H501I', 'In attesa', 'contanti'),
(600.00, '2025-05-10', '11:00:00', 'MRTGNN89L10H501L', 'Rifiutata', 'carta'),
(550.00, '2025-05-11', '12:30:00', 'BRNGPP90M11H501M', 'Accettata', 'bonifico'),
(500.00, '2025-05-12', '13:45:00', 'RMNNNA91N12H501N', 'In attesa', 'contanti'),
(700.00, '2025-05-13', '14:30:00', 'GLLCRL92P13H501P', 'Accettata', 'carta'),
(600.00, '2025-05-14', '15:00:00', 'RSSLRA93Q14H501Q', 'Accettata', 'bonifico'),
(550.00, '2025-05-15', '16:00:00', 'BNCFBA94R15H501R', 'In attesa', 'contanti'),
(500.00, '2025-05-16', '17:00:00', 'VLNLSA95S16H501S', 'Rifiutata', 'carta'),
(700.00, '2025-05-17', '09:30:00', 'RSSMTA96T17H501T', 'Accettata', 'bonifico'),
(600.00, '2025-05-18', '10:30:00', 'CNTDVD97U18H501U', 'In attesa', 'contanti'),
(550.00, '2025-05-19', '11:15:00', 'FRRSRA98V19H501V', 'Accettata', 'carta'),
(500.00, '2025-05-20', '12:00:00', 'MTTPLA99Z20H501Z', 'In attesa', 'bonifico');

INSERT INTO Patente (TipoPatente, Descrizione) VALUES
('A', 'Motocicli senza limitazioni'),
('A1', 'Motocicli leggeri fino a 125cc'),
('A2', 'Motocicli di media potenza fino a 35kW'),
('AM', 'Ciclomotori 50cc'),
('B', 'Autovetture e veicoli fino a 3500kg'),
('B1', 'Quadricicli'),
('BE', 'Auto con rimorchio'),
('B96', 'Auto con rimorchio tra 3500kg e 4250kg'),
('C', 'Camion oltre 3500kg'),
('C1', 'Camion medi tra 3500kg e 7500kg'),
('CE', 'Camion con rimorchio'),
('C1E', 'Camion medi con rimorchio'),
('D', 'Autobus oltre 9 posti'),
('D1', 'Minibus fino a 16 posti'),
('DE', 'Autobus con rimorchio'),
('D1E', 'Minibus con rimorchio'),
('M', 'Macchine operatrici');

INSERT INTO Abilitazione (IstruttoreCF, TipoPatente) VALUES
('BNCMRA70A01H501X', 'B'),
('BNCMRA70A01H501X', 'A'),
('RSSGVN75B02H501Y', 'C'),
('RSSGVN75B02H501Y', 'B'),
('VRDLCA80C03H501Z', 'A'),
('VRDLCA80C03H501Z', 'B'),
('NRIGPP85D04H501W', 'D'),
('NRIGPP85D04H501W', 'C'),
('BNCNNA90E05H501V', 'B'),
('BNCNNA90E05H501V', 'BE'),
('RSSMRA75F06H501U', 'A1'),
('RSSMRA75F06H501U', 'A2'),
('VRDPLA80G07H501T', 'AM'),
('VRDPLA80G07H501T', 'B'),
('NRILCU85H08H501S', 'C1'),
('NRILCU85H08H501S', 'CE'),
('BNCFBA90I09H501R', 'D1'),
('BNCFBA90I09H501R', 'DE'),
('RSSSFN75L10H501Q', 'B96'),
('RSSSFN75L10H501Q', 'M');

--Query 1
SELECT 
    i.TipoPatente,
    COUNT(*) as NumeroEsami,
    AVG(e.Punti) as MediaPunti,
    COUNT(e.Esito) as NumeroPromossi
FROM Iscritto i
JOIN Esame e ON i.CodiceFiscale = e.CodiceFiscale
WHERE e.TipoEsame = 'Teorico'
GROUP BY i.TipoPatente
HAVING AVG(e.Punti) > 20
ORDER BY MediaPunti DESC;

--Query 2
SELECT 
    v.TipoVeicolo,
    COUNT(*) as NumeroVeicoli,
    COUNT(CASE WHEN v.Stato = 'Disponibile' THEN 1 END) as VeicoliDisponibili,
    COUNT(DISTINCT i.TipoPatente) as TipiPatentiNecessarie,
    COUNT(DISTINCT p.DataPrenotazione) as NumeroPrenotazioni
FROM Veicolo v
JOIN Iscritto i ON (
    (v.TipoVeicolo = 'Auto' AND i.TipoPatente = 'B') OR
    (v.TipoVeicolo = 'Moto' AND i.TipoPatente = 'A') OR
    (v.TipoVeicolo = 'Camion' AND i.TipoPatente = 'C')
)
LEFT JOIN Prenotazione p ON i.CodiceFiscale = p.CodiceFiscale
GROUP BY v.TipoVeicolo
ORDER BY NumeroVeicoli DESC;

--Query 3
SELECT 
    v.TipoVeicolo,
    v.Modello,
    v.Stato,
    p.DataPrenotazione,
    p.Ora,
    i.Nome,
    i.Cognome
FROM Veicolo v
JOIN Prenotazione p ON v.Stato = 'Disponibile'
JOIN Iscritto i ON p.CodiceFiscale = i.CodiceFiscale
WHERE v.Stato = 'Disponibile'
    AND p.Stato = 'Accettata'
ORDER BY p.DataPrenotazione, p.Ora;


--Query 4
SELECT I.Nome, P.CodiceFiscale, I.TipoPatente, SUM(P.Importo) AS TotalePagato
FROM Pagamento P
JOIN Iscritto I ON P.CodiceFiscale = I.CodiceFiscale
GROUP BY I.Nome, P.CodiceFiscale, I.TipoPatente
HAVING SUM(P.Importo) > 0;

--Query 5
SELECT 
    I.Nome,
    I.Cognome,
    AVG(R.Gradimento) AS MediaGradimento,
    COUNT(*) AS NumeroRecensioni
FROM Istruttore I
JOIN Recensione R ON I.CodiceFiscale = R.CFIstruttore
JOIN Iscritto S ON R.CodiceFiscale = S.CodiceFiscale
GROUP BY I.CodiceFiscale, I.Nome, I.Cognome
HAVING AVG(R.Gradimento) > 4.0
ORDER BY MediaGradimento DESC;

--Indici
CREATE INDEX idx_veicolo_stato 
ON Veicolo USING hash(stato);

CREATE INDEX idx_prenotazione_cf_stato_data_ora 
ON Prenotazione(CodiceFiscale, Stato, DataPrenotazione, Ora);
