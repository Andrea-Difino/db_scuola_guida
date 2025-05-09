CREATE TABLE Iscritto (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    DataIscrizione DATE,
    TipoPatente TEXT CHECK(TipoPatente IN
    (
        'A', 'A1', 'A2', 'AM', 'B', 'B1', 'BE', 'B96',
        'C', 'C1', 'CE', 'C1E', 'D', 'D1', 'DE', 'D1E', 'M'
    )),
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Indirizzo VARCHAR(20),
    Email VARCHAR(25) UNIQUE,
    Numero VARCHAR(25) UNIQUE
);

CREATE TABLE Esame (
    Data DATE,
    CodiceFiscale CHAR(16),
    TipoEsame TEXT CHECK(TipoEsame IN ('Teorico', 'Pratico')),
    Durata INTEGER,
    Esito BOOLEAN,
    Sede VARCHAR(30) NULL,
    Punti INTEGER NULL,
    PRIMARY KEY (Data, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Partecipazione (
    CodiceFiscale CHAR(16),
    Data DATE,
    PRIMARY KEY (CodiceFiscale, Data),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale),
    FOREIGN KEY (Data, CodiceFiscale) REFERENCES Esame(Data, CodiceFiscale)
);



CREATE TABLE Recensione (
    CodiceFiscale CHAR(16),
    Oggetto VARCHAR(50),
    Commento TEXT,
    Email VARCHAR(30),
    Data DATE,
    Gradimento INTEGER CHECK(Gradimento BETWEEN 1 AND 5),
    PRIMARY KEY (CodiceFiscale, Oggetto),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Lezione (
    Data DATE,
    ArgomentoLezione VARCHAR(50),
    TipoLezione TEXT CHECK(TipoLezione IN ('Teorico', 'Pratico')),
    OraInizio TIME,
    Durata INTEGER NULL,
    PRIMARY KEY (Data, ArgomentoLezione)
);

CREATE TABLE ValutazioneLezione (
    CodiceFiscale CHAR(16),
    Oggetto VARCHAR(50),
    DataLezione DATE,
    ArgomentoLezione VARCHAR(50),
    PRIMARY KEY (CodiceFiscale, Oggetto, DataLezione, ArgomentoLezione),
    FOREIGN KEY (CodiceFiscale, Oggetto) REFERENCES Recensione(CodiceFiscale, Oggetto),
    FOREIGN KEY (DataLezione, ArgomentoLezione) REFERENCES Lezione(Data, ArgomentoLezione)
);

CREATE TABLE Prenotazione (
    DataPrenotazione DATE,
    CodiceFiscale CHAR(16),
    Ora TIME,
    Stato TEXT CHECK(Stato IN ('Accettata', 'Rifiutata', 'In attesa')),
    PRIMARY KEY (DataPrenotazione, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Pagamento (
    Importo DECIMAL(10, 2),
    Data DATE,
    CodiceFiscale CHAR(16),
    Stato TEXT CHECK(Stato IN ('Accettata', 'Rifiutata', 'In attesa')),
    MetodoPagamento TEXT CHECK(MetodoPagamento IN ('carta', 'contanti', 'bonifico')),
    PRIMARY KEY (Importo, Data, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Veicolo (
    Targa CHAR(7) PRIMARY KEY,
    Modello VARCHAR(30),
    AnnoImmatricolazione INTEGER CHECK (AnnoImmatricolazione BETWEEN 1980 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    Stato TEXT CHECK(Stato IN ('Disponibile', 'In Manutenzione', 'Non Disponibile')),
    TipoVeicolo TEXT CHECK(TipoVeicolo IN ('Auto', 'Moto', 'Camion'))
);

CREATE TABLE Citta (
    CodiceCatastale VARCHAR(4) PRIMARY KEY,
    NomeCitta VARCHAR(30),
    CAP VARCHAR(5),
    Provincia VARCHAR(2)
);

CREATE TABLE Aula (
    NomeAula VARCHAR(20) PRIMARY KEY,
    Posti INTEGER,
    Attrezzatura TEXT CHECK(Attrezzatura IN ('Proiettore', 'Lavagna', 'LIM', 'Impianto Audio'))
);

CREATE TABLE Istruttore (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    AnniEsperienza INTEGER,
    Abilitazione VARCHAR(4),
    Numero VARCHAR(12) UNIQUE,
    Email VARCHAR (30) UNIQUE
);

CREATE TABLE ValutazioneIstruttore (
    CodiceFiscale CHAR(16),               
    Oggetto VARCHAR(50),
    CodiceFiscaleIstruttore CHAR(16),    
    PRIMARY KEY (CodiceFiscale, Oggetto, CodiceFiscaleIstruttore),
    FOREIGN KEY (CodiceFiscale, Oggetto) REFERENCES Recensione(CodiceFiscale, Oggetto),
    FOREIGN KEY (CodiceFiscaleIstruttore) REFERENCES Istruttore(CodiceFiscale)
);

CREATE TABLE Patente (
    TipoPatente TEXT PRIMARY KEY CHECK (TipoPatente IN (
        'A', 'A1', 'A2', 'AM', 'B', 'B1', 'BE', 'B96',
        'C', 'C1', 'CE', 'C1E', 'D', 'D1', 'DE', 'D1E', 'M'
    )),
    Descrizione TEXT
);

CREATE TABLE Abilitazione (
    IstruttoreCF CHAR(16),
    TipoPatente TEXT,
    PRIMARY KEY (IstruttoreCF, TipoPatente),
    FOREIGN KEY (IstruttoreCF) REFERENCES Istruttore(CodiceFiscale),
    FOREIGN KEY (TipoPatente) REFERENCES Patente(TipoPatente)
);

-- Populate Iscritto
INSERT INTO Iscritto (CodiceFiscale, DataIscrizione, TipoPatente, Nome, Cognome, Indirizzo, Email, Numero) VALUES
('RSSMRA80A01H501A', '2025-01-01', 'B', 'Mario', 'Rossi', 'Via Roma 1', 'mario.rossi@email.it', '3331234567'),
('VRDLCA81B02H501B', '2025-01-02', 'A', 'Luca', 'Verdi', 'Via Milano 2', 'luca.verdi@email.it', '3331234568'),
('BNCGPP82C03H501C', '2025-01-03', 'C', 'Giuseppe', 'Bianchi', 'Via Napoli 3', 'giuseppe.b@email.it', '3331234569'),
('NRENNA83D04H501D', '2025-01-04', 'B', 'Anna', 'Neri', 'Via Torino 4', 'anna.neri@email.it', '3331234570'),
('GLLMRC84E05H501E', '2025-01-05', 'A1', 'Marco', 'Gialli', 'Via Palermo 5', 'marco.g@email.it', '3331234571'),
('VLNSFN85F06H501F', '2025-01-06', 'B', 'Stefano', 'Viola', 'Via Genova 6', 'stefano.v@email.it', '3331234572'),
('RSSMRA86G07H501G', '2025-01-07', 'C1', 'Maria', 'Russo', 'Via Firenze 7', 'maria.r@email.it', '3331234573'),
('CNTLCA87H08H501H', '2025-01-08', 'B', 'Luca', 'Conti', 'Via Bologna 8', 'luca.c@email.it', '3331234574'),
('FRRPLA88I09H501I', '2025-01-09', 'A2', 'Paola', 'Ferrari', 'Via Venezia 9', 'paola.f@email.it', '3331234575'),
('MRTGNN89L10H501L', '2025-01-10', 'B', 'Gianna', 'Moretti', 'Via Bari 10', 'gianna.m@email.it', '3331234576'),
('BRNGPP90M11H501M', '2025-01-11', 'B', 'Giuseppe', 'Bruni', 'Via Catania 11', 'giuseppe@email.it', '3331234577'),
('RMNNNA91N12H501N', '2025-01-12', 'A', 'Anna', 'Romano', 'Via Verona 12', 'anna.rom@email.it', '3331234578'),
('GLLCRL92P13H501P', '2025-01-13', 'B', 'Carlo', 'Galli', 'Via Messina 13', 'carlo.g@email.it', '3331234579'),
('RSSLRA93Q14H501Q', '2025-01-14', 'C', 'Laura', 'Rossi', 'Via Padova 14', 'laura.r@email.it', '3331234580'),
('BNCFBA94R15H501R', '2025-01-15', 'B', 'Fabio', 'Bianchi', 'Via Trieste 15', 'fabio.b@email.it', '3331234581'),
('VLNLSA95S16H501S', '2025-01-16', 'A1', 'Elisa', 'Viola', 'Via Rimini 16', 'elisa.v@email.it', '3331234582'),
('RSSMTA96T17H501T', '2025-01-17', 'B', 'Marta', 'Rossi', 'Via Parma 17', 'marta.r@email.it', '3331234583'),
('CNTDVD97U18H501U', '2025-01-18', 'B', 'Davide', 'Conti', 'Via Pisa 18', 'davide.c@email.it', '3331234584'),
('FRRSRA98V19H501V', '2025-01-19', 'A2', 'Sara', 'Ferrari', 'Via Latina 19', 'sara.f@email.it', '3331234585'),
('MTTPLA99Z20H501Z', '2025-01-20', 'B', 'Paolo', 'Motti', 'Via Siena 20', 'paolo.m@email.it', '3331234586');

-- Populate Esame
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

-- Populate Partecipazione
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

-- Populate Recensione
INSERT INTO Recensione (CodiceFiscale, Oggetto, Commento, Email, Data, Gradimento) VALUES
('RSSMRA80A01H501A', 'Ottimo corso', 'Istruttori molto preparati', 'mario.rossi@email.it', '2025-03-01', 5),
('VRDLCA81B02H501B', 'Buona esperienza', 'Corso ben strutturato', 'luca.verdi@email.it', '2025-03-02', 4),
('BNCGPP82C03H501C', 'Soddisfatto', 'Ottimo rapporto qualità/prezzo', 'giuseppe.b@email.it', '2025-03-03', 5),
('NRENNA83D04H501D', 'Esperienza positiva', 'Personale disponibile', 'anna.neri@email.it', '2025-03-04', 4),
('GLLMRC84E05H501E', 'Da migliorare', 'Orari poco flessibili', 'marco.g@email.it', '2025-03-05', 3),
('VLNSFN85F06H501F', 'Molto professionale', 'Consigliato', 'stefano.v@email.it', '2025-03-06', 5),
('RSSMRA86G07H501G', 'Corso eccellente', 'Ottima preparazione', 'maria.r@email.it', '2025-03-07', 5),
('CNTLCA87H08H501H', 'Buon corso', 'Istruttori pazienti', 'luca.c@email.it', '2025-03-08', 4),
('FRRPLA88I09H501I', 'Esperienza ok', 'Corso nella media', 'paola.f@email.it', '2025-03-09', 3),
('MRTGNN89L10H501L', 'Molto soddisfatta', 'Ottima scuola', 'gianna.m@email.it', '2025-03-10', 5),
('BRNGPP90M11H501M', 'Corso completo', 'Ben organizzato', 'giuseppe@email.it', '2025-03-11', 4),
('RMNNNA91N12H501N', 'Esperienza positiva', 'Consigliato', 'anna.rom@email.it', '2025-03-12', 4),
('GLLCRL92P13H501P', 'Ottimo servizio', 'Personale competente', 'carlo.g@email.it', '2025-03-13', 5),
('RSSLRA93Q14H501Q', 'Corso efficace', 'Preparazione completa', 'laura.r@email.it', '2025-03-14', 4),
('BNCFBA94R15H501R', 'Buona scuola', 'Ambiente professionale', 'fabio.b@email.it', '2025-03-15', 4),
('VLNLSA95S16H501S', 'Esperienza positiva', 'Consigliata', 'elisa.v@email.it', '2025-03-16', 5),
('RSSMTA96T17H501T', 'Corso valido', 'Ottimi istruttori', 'marta.r@email.it', '2025-03-17', 4),
('CNTDVD97U18H501U', 'Soddisfatto', 'Buon rapporto qualità/prezzo', 'davide.c@email.it', '2025-03-18', 4),
('FRRSRA98V19H501V', 'Ottima scelta', 'Preparazione eccellente', 'sara.f@email.it', '2025-03-19', 5),
('MTTPLA99Z20H501Z', 'Corso consigliato', 'Esperienza positiva', 'paolo.m@email.it', '2025-03-20', 4);

-- Populate Prenotazione
INSERT INTO Prenotazione (DataPrenotazione, CodiceFiscale, Ora, Stato) VALUES
('2025-05-01', 'RSSMRA80A01H501A', '09:00:00', 'Accettata'),
('2025-05-02', 'VRDLCA81B02H501B', '10:00:00', 'In attesa'),
('2025-05-03', 'BNCGPP82C03H501C', '11:00:00', 'Accettata'),
('2025-05-04', 'NRENNA83D04H501D', '14:00:00', 'Rifiutata'),
('2025-05-05', 'GLLMRC84E05H501E', '15:00:00', 'Accettata'),
('2025-05-06', 'VLNSFN85F06H501F', '16:00:00', 'In attesa'),
('2025-05-07', 'RSSMRA86G07H501G', '09:00:00', 'Accettata'),
('2025-05-08', 'CNTLCA87H08H501H', '10:00:00', 'Accettata'),
('2025-05-09', 'FRRPLA88I09H501I', '11:00:00', 'In attesa'),
('2025-05-10', 'MRTGNN89L10H501L', '14:00:00', 'Rifiutata'),
('2025-05-11', 'BRNGPP90M11H501M', '15:00:00', 'Accettata'),
('2025-05-12', 'RMNNNA91N12H501N', '16:00:00', 'In attesa'),
('2025-05-13', 'GLLCRL92P13H501P', '09:00:00', 'Accettata'),
('2025-05-14', 'RSSLRA93Q14H501Q', '10:00:00', 'Accettata'),
('2025-05-15', 'BNCFBA94R15H501R', '11:00:00', 'In attesa'),
('2025-05-16', 'VLNLSA95S16H501S', '14:00:00', 'Rifiutata'),
('2025-05-17', 'RSSMTA96T17H501T', '15:00:00', 'Accettata'),
('2025-05-18', 'CNTDVD97U18H501U', '16:00:00', 'In attesa'),
('2025-05-19', 'FRRSRA98V19H501V', '09:00:00', 'Accettata'),
('2025-05-20', 'MTTPLA99Z20H501Z', '10:00:00', 'In attesa');

-- Populate Pagamento
INSERT INTO Pagamento (Importo, Data, CodiceFiscale, Stato, MetodoPagamento) VALUES
(500.00, '2025-05-01', 'RSSMRA80A01H501A', 'Accettata', 'carta'),
(600.00, '2025-05-02', 'VRDLCA81B02H501B', 'In attesa', 'bonifico'),
(550.00, '2025-05-03', 'BNCGPP82C03H501C', 'Accettata', 'contanti'),
(500.00, '2025-05-04', 'NRENNA83D04H501D', 'Rifiutata', 'carta'),
(700.00, '2025-05-05', 'GLLMRC84E05H501E', 'Accettata', 'bonifico'),
(600.00, '2025-05-06', 'VLNSFN85F06H501F', 'In attesa', 'contanti'),
(550.00, '2025-05-07', 'RSSMRA86G07H501G', 'Accettata', 'carta'),
(500.00, '2025-05-08', 'CNTLCA87H08H501H', 'Accettata', 'bonifico'),
(700.00, '2025-05-09', 'FRRPLA88I09H501I', 'In attesa', 'contanti'),
(600.00, '2025-05-10', 'MRTGNN89L10H501L', 'Rifiutata', 'carta'),
(550.00, '2025-05-11', 'BRNGPP90M11H501M', 'Accettata', 'bonifico'),
(500.00, '2025-05-12', 'RMNNNA91N12H501N', 'In attesa', 'contanti'),
(700.00, '2025-05-13', 'GLLCRL92P13H501P', 'Accettata', 'carta'),
(600.00, '2025-05-14', 'RSSLRA93Q14H501Q', 'Accettata', 'bonifico'),
(550.00, '2025-05-15', 'BNCFBA94R15H501R', 'In attesa', 'contanti'),
(500.00, '2025-05-16', 'VLNLSA95S16H501S', 'Rifiutata', 'carta'),
(700.00, '2025-05-17', 'RSSMTA96T17H501T', 'Accettata', 'bonifico'),
(600.00, '2025-05-18', 'CNTDVD97U18H501U', 'In attesa', 'contanti'),
(550.00, '2025-05-19', 'FRRSRA98V19H501V', 'Accettata', 'carta'),
(500.00, '2025-05-20', 'MTTPLA99Z20H501Z', 'In attesa', 'bonifico');

-- Populate Veicolo
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

-- Populate Citta
INSERT INTO Citta (CodiceCatastale, NomeCitta, CAP, Provincia) VALUES
('H501', 'Roma', '00100', 'RM'),
('F205', 'Milano', '20100', 'MI'),
('A944', 'Bologna', '40100', 'BO'),
('F839', 'Napoli', '80100', 'NA'),
('L219', 'Torino', '10100', 'TO'),
('D612', 'Firenze', '50100', 'FI'),
<<<<<<< HEAD
('A662', 'Bari', '70100', 'BA'),
=======
('A622', 'Bari', '70100', 'BA'),
>>>>>>> b229d04dfc6167f63f52be9f20b10bac2ccf6828
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

-- Populate Aula
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

-- Populate Istruttore
INSERT INTO Istruttore (CodiceFiscale, Nome, Cognome, AnniEsperienza, Abilitazione, Numero, Email) VALUES
('BNCMRA70A01H501X', 'Mario', 'Bianchi', 15, 'ABCD', '321234567890', 'mario.bianchi@scuola.it'),
('RSSGVN75B02H501Y', 'Giovanni', 'Rossi', 12, 'EFGH', '322234567890', 'giovanni.rossi@scuola.it'),
('VRDLCA80C03H501Z', 'Luca', 'Verdi', 10, 'ILMN', '323234567890', 'luca.verdi@scuola.it'),
('NRIGPP85D04H501W', 'Giuseppe', 'Neri', 8, 'OPQR', '324234567890', 'giuseppe.neri@scuola.it'),
('BNCNNA90E05H501V', 'Anna', 'Bianchi', 7, 'STUV', '325234567890', 'anna.bianchi@scuola.it'),
('RSSMRA75F06H501U', 'Maria', 'Rossi', 13, 'ZABC', '326234567890', 'maria.rossi@scuola.it'),
('VRDPLA80G07H501T', 'Paolo', 'Verdi', 11, 'DEFG', '327234567890', 'paolo.verdi@scuola.it'),
('NRILCU85H08H501S', 'Lucia', 'Neri', 9, 'HILM', '328234567890', 'lucia.neri@scuola.it'),
('BNCFBA90I09H501R', 'Fabio', 'Bianchi', 6, 'NOPQ', '329234567890', 'fabio.bianchi@scuola.it'),
('RSSSFN75L10H501Q', 'Stefano', 'Rossi', 14, 'RSTU', '330234567890', 'stefano.rossi@scuola.it'),
('VRDMRC80M11H501P', 'Marco', 'Verdi', 12, 'VWXY', '331234567890', 'marco.verdi@scuola.it');

-- Populate Lezione
INSERT INTO Lezione (Data, ArgomentoLezione, TipoLezione, OraInizio, Durata) VALUES
('2025-04-01', 'Segnaletica stradale', 'Teorico', '09:00:00', NULL),
('2025-04-02', 'Precedenze', 'Teorico', '11:00:00', NULL),
('2025-04-03', 'Parcheggio', 'Pratico', '14:00:00', 60),
('2025-04-04', 'Codice della strada', 'Teorico', '09:00:00', NULL),
('2025-04-05', 'Guida in città', 'Pratico', '11:00:00', 60),
('2025-04-06', 'Sicurezza stradale', 'Teorico', '14:00:00', NULL),
('2025-04-07', 'Manovre base', 'Pratico', '09:00:00', 60),
('2025-04-08', 'Limiti di velocità', 'Teorico', '11:00:00', NULL),
('2025-04-09', 'Guida notturna', 'Pratico', '14:00:00', 60),
('2025-04-10', 'Emergenze', 'Teorico', '09:00:00', NULL),
('2025-04-11', 'Autostrada', 'Pratico', '11:00:00', 60),
('2025-04-12', 'Meccanica base', 'Teorico', '14:00:00', NULL),
('2025-04-13', 'Parcheggio parallelo', 'Pratico', '09:00:00', 60),
('2025-04-14', 'Primo soccorso', 'Teorico', '11:00:00', NULL),
('2025-04-15', 'Guida eco', 'Pratico', '14:00:00', 60),
('2025-04-16', 'Meteo e guida', 'Teorico', '09:00:00', NULL),
('2025-04-17', 'Rotatorie', 'Pratico', '11:00:00', 60),
('2025-04-18', 'Documenti auto', 'Teorico', '14:00:00', NULL),
('2025-04-19', 'Guida sportiva', 'Pratico', '09:00:00', 60),
('2025-04-20', 'Manutenzione', 'Teorico', '11:00:00', NULL);

-- Populate Patente
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

-- Populate Abilitazione
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