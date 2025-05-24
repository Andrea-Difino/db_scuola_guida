#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <libpq-fe.h>

#define DB_NAME "scuola_guidaDB"
#define DB_USER "postgres"
#define DB_PASS "PostGreeAndre14"
#define DB_HOST "127.0.0.1"
#define DB_PORT "5432"

PGconn *conn;

void connectDB() {
    char conninfo[256];
    snprintf(conninfo, sizeof(conninfo),
             "dbname=%s user=%s password=%s hostaddr=%s port=%s",
             DB_NAME, DB_USER, DB_PASS, DB_HOST, DB_PORT);

    conn = PQconnectdb(conninfo);
    if (PQstatus(conn) != CONNECTION_OK) {
        fprintf(stderr, "Errore di connessione: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(EXIT_FAILURE);
    }
}

void upperText(char *dst, const char *src) {
    while (*src) {
        *dst++ = toupper((unsigned char)*src++);
    }
    *dst = '\0';
}

void runQuery(const char *query) {
    PGresult *res = PQexec(conn, query);

    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf("Errore nella query o nessun risultato: %s\n", PQresultErrorMessage(res));
        PQclear(res);
        return;
    }

    int cols = PQnfields(res);
    for (int i = 0; i < cols; i++) {
        char header[256];
        upperText(header, PQfname(res, i));
        printf("%-30s", header);
    }
    printf("\n");

    for (int i = 0; i < PQntuples(res); i++) {
        for (int j = 0; j < cols; j++) {
            printf("%-30s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }

    PQclear(res);
}

const char *queries[] = {
    NULL,
    "SELECT v.TipoVeicolo, COUNT(*) as NumeroVeicoli, COUNT(CASE WHEN v.Stato = 'Disponibile' THEN 1 END) as VeicoliDisponibili, COUNT(DISTINCT i.TipoPatente) as TipiPatentiNecessarie, COUNT(DISTINCT p.DataPrenotazione) as NumeroPrenotazioni FROM Veicolo v JOIN Iscritto i ON ((v.TipoVeicolo = 'Auto' AND i.TipoPatente = 'B') OR (v.TipoVeicolo = 'Moto' AND i.TipoPatente = 'A') OR (v.TipoVeicolo = 'Camion' AND i.TipoPatente = 'C')) LEFT JOIN Prenotazione p ON i.CodiceFiscale = p.CodiceFiscale GROUP BY v.TipoVeicolo ORDER BY NumeroVeicoli DESC;",
    "SELECT v.TipoVeicolo, v.Modello, v.Stato, p.DataPrenotazione, p.Ora, i.Nome, i.Cognome FROM Veicolo v JOIN Prenotazione p ON v.Stato = 'Disponibile' JOIN Iscritto i ON p.CodiceFiscale = i.CodiceFiscale WHERE v.Stato = 'Disponibile' AND p.Stato = 'Accettata' ORDER BY p.DataPrenotazione, p.Ora;",
    NULL, 
    NULL  
};

void print_menu() {
    printf("\n----- MENU QUERIES -----\n");
    printf("1. Media punti e numero promossi per tipo patente\n");
    printf("2. Info veicoli e tipi patenti necessarie\n");
    printf("3. Prenotazioni accettate per veicoli disponibili\n");
    printf("4. Pagamenti per Iscritto (parametrico)\n");
    printf("5. Gradimento istruttori (parametrico)\n");
    printf("7. Uscire\n");
    printf("Seleziona un'opzione: ");
}

int main() {
    connectDB();

    int option = 0;
    while (1) {
        print_menu();
        if (scanf("%d", &option) != 1) {
            while (getchar() != '\n');
            printf("Input non valido. Riprova.\n");
            continue;
        }

        if (option == 1) {
            double soglia;
            printf("Inserisci la soglia minima di punti per filtrare i risultati (es. 20): ");
            if (scanf("%lf", &soglia) != 1) {
                while (getchar() != '\n');
                printf("Input non valido.\n");
                continue;
            }

            char query[1024];
            snprintf(query, sizeof(query),
                "SELECT i.TipoPatente, COUNT(*) as NumeroEsami, AVG(e.Punti) as MediaPunti, COUNT(e.Esito) as NumeroPromossi "
                "FROM Iscritto i "
                "JOIN Esame e ON i.CodiceFiscale = e.CodiceFiscale "
                "WHERE e.TipoEsame = 'Teorico' "
                "GROUP BY i.TipoPatente "
                "HAVING AVG(e.Punti) > %.2f "
                "ORDER BY MediaPunti DESC;",
                soglia);

            runQuery(query);

        } else if (option == 4) {
            double importo;
            printf("Inserisci l'importo minimo pagato (es. 0): ");
            if (scanf("%lf", &importo) != 1) {
                while (getchar() != '\n');
                printf("Input non valido.\n");
                continue;
            }

            char query[1024];
            snprintf(query, sizeof(query),
                "SELECT I.Nome, P.CodiceFiscale, I.TipoPatente, SUM(P.Importo) AS TotalePagato "
                "FROM Pagamento P "
                "JOIN Iscritto I ON P.CodiceFiscale = I.CodiceFiscale "
                "GROUP BY I.Nome, P.CodiceFiscale, I.TipoPatente "
                "HAVING SUM(P.Importo) > %.2f;",
                importo);

            runQuery(query);

        } else if (option == 5) {
            double gradimento;
            printf("Inserisci la soglia minima di gradimento (es. 4.0): ");
            if (scanf("%lf", &gradimento) != 1) {
                while (getchar() != '\n');
                printf("Input non valido.\n");
                continue;
            }

            char query[1024];
            snprintf(query, sizeof(query),
                "SELECT I.Nome, I.Cognome, AVG(R.Gradimento) AS MediaGradimento, COUNT(*) AS NumeroRecensioni "
                "FROM Istruttore I "
                "JOIN Recensione R ON I.CodiceFiscale = R.CFIstruttore "
                "JOIN Iscritto S ON R.CodiceFiscale = S.CodiceFiscale "
                "GROUP BY I.CodiceFiscale, I.Nome, I.Cognome "
                "HAVING AVG(R.Gradimento) > %.2f "
                "ORDER BY MediaGradimento DESC;",
                gradimento);

            runQuery(query);

        } else if (option == 2 || option == 3) {
            printf("\n");
            runQuery(queries[option - 1]);

        } else if (option == 7) {
            printf("Chiusura programma...\n");
            break;

        } else {
            printf("Opzione non valida.\n");
        }
    }

    PQfinish(conn);
    return 0;
}
