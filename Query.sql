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

CREATE TABLE Prenotazione (
    DataPrenotazione DATE,
    CodiceFiscale CHAR(16),
    Ora TIME,
    Stato TEXT CHECK(Stato IN ('Accetta', 'Rifiutata', 'In attesa')),
    PRIMARY KEY (DataPrenotazione, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Pagamento (
    Importo DECIMAL(10, 2),
    Data DATE,
    CodiceFiscale CHAR(16),
    Stato TEXT CHECK(Stato IN ('Accetta', 'Rifiutata', 'In attesa')),
    MetodoPagamento TEXT CHECK(MetodoPagamento IN ('carta', 'contanti', 'bonifico')),
    PRIMARY KEY (Importo, Data, CodiceFiscale),
    FOREIGN KEY (CodiceFiscale) REFERENCES Iscritto(CodiceFiscale)
);

CREATE TABLE Veicolo (
    Targa CHAR(7) PRIMARY KEY,
    Modello VARCHAR(30),
    AnnoImmatricolazione YEAR,
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

CREATE TABLE Patente (
    Tipo TEXT PRIMARY KEY CHECK (Tipo IN (
        'A', 'A1', 'A2', 'AM', 'B', 'B1', 'BE', 'B96',
        'C', 'C1', 'CE', 'C1E', 'D', 'D1', 'DE', 'D1E', 'M'
    ))
);

CREATE TABLE Abilitazione (
    IstruttoreCF CHAR(16),
    TipoPatente TEXT,
    PRIMARY KEY (IstruttoreCF, TipoPatente),
    FOREIGN KEY (IstruttoreCF) REFERENCES Istruttore(CodiceFiscale),
    FOREIGN KEY (TipoPatente) REFERENCES Patente(TipoPatente)
);