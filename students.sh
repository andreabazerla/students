#!/bin/bash
# SHEBANG: indico quale interprete usare per eseguire lo script

#############################################
########## SISTEMI OPERATIVI ################
########## ELABORATO N° 1 ###################
########## Andrea Bazerla VR377556 ##########
#############################################

# FILE: creo il file studenti.txt se non esiste
# Pre creare un file .txt vuoto uso il comando touch se non esiste
# Se invece esiste già aggiorno la data di accesso/modifica con la data corrente visto che non l'ho specificata grazie alle opzioni -a e -m
function file {
	touch -a -m studenti.txt
}

# INIT: inizio del programma
function init {
	menu # Stampo il menu
	input # Chiedo un input
	selezione # Seleziono una voce
}

# MENU: stampo le 7 voci del menu
# Ogni voce del menu la assegno come stringa ad una variabile rowN dove N è il numero di riga
# Poi accedendoci con l'operatore $ le concateno e le assegno tutte alla variabile menu
# Infine stampo menu con l'opzione -e per abilitare l'interpretazione delle backslash \n per andare a capo e \t per aggiungere una tabulazione 
function menu {
	row0="\n\tMENU\n"
	row1="\t1. Aggiungi\n"
	row2="\t2. Elimina\n"
	row3="\t3. Mostra elenco\n"
	row4="\t4. Ricerca\n"
	row5="\t5. Iscritti per anno\n"
	row6="\t6. Controlla matricole\n"
	row7="\t7. Esci\n"
	menu=$row0$row1$row2$row3$row4$row5$row6$row7
	echo -e $menu
}

# INPUT: chiedo all'utente di inserire un numero per la selezione di una voce del menu
# Acquisisco un valore dallo standard input inserito dall'utente sulla shell con la tastiera e lo memorizzo nella variabile row
function input {
	echo -e "Inserisci un numero: \c"
	read row
}

# SELEZIONE: funzione per la selezione di una voce del menu a seconda dell'input inserito
function selezione {
	clear

	# In questo switch uso come selettore $row cioè l'input acquisito dalla funzione input
	# Le guardie dei casi sono considerate come stringhe e quindi a seconda del loro valore eseguo una funzione diversa
	case $row in
		1) aggiungi ;; # Aggiunge uno studente secondo il formato CSV <nome>;<cognome>;<matricola>;<anno> (<> esclusi)
		2) elimina ;; # Elimina uno studente con l'inerimento di una matricola
		3) mostra ;; # Mostra tutti gli studenti ordinati per matricola
		4) ricerca ;; # Ricerca uno studente in base al suo cognome ordinati prima per cognome e poi per nome
		5) iscritti ;; # Mostra il numero degli studenti iscritti per anno
		6) controlla ;; # Controlla la validità delle matricole degli studenti registrati
		7) esci ;; # Esce dal programma
		*) # Se non viene inserito come input un valore compreso tra 1 e 7 eseguo le seguenti funzioni
			error # Segnala un errore
			menu # Ristampa il menu
			input # Richiede di inserire un input 
			selezione # Riesegue questa funzione per la selezione di una nuova voce
		;;
	esac # Chiusura dello switch
	
}

# ERRORE: stampo un errore per segnalare che l'input inserito per la selezione di una voce del menu non è valido
function error {
	echo -e "ERRORE: numero non valido, riprova"
}

# ESCI: esco dal programma
function esci {
	exit
}

# 1. AGGIUNGI: funzione per aggiungere uno studente in coda al file studenti.txt
# Uso il formato CSV <nome>;<cognome>;<matricola>;<anno> (<> esclusi)
function aggiungi {

	# NOME
	echo -e "1. AGGIUNGI"
	echo -e "Inserire nome:"
	# Leggo il nome
	read nome
	# Finchè il nome inserito è uguale ad una stringa vuota segnalo un errore e continuo a richiederlo
	while [ "$nome" = "" ]
	do
		echo -e "ERRORE: campo inserito vuoto"
		echo -e "Inserire nome:"
		read nome
	done

	# COGNOME
	echo -e "Inserire cognome:"
	# Leggo il cognome
	read cognome
	# Stessa cosa come per il nome
	while [ "$cognome" = "" ]
	do
		echo -e "ERRORE: campo inserito vuoto"
		echo -e "Inserire cognome:"
		read cognome
	done

	# MATRICOLA
	echo -e "Inserire matricola:"
	# Leggo la matricola
	read matricola
	# Finché la matricola inserita è uguale ad una stringa vuota oppure è già presente nel file studenti.txt segnalo un errore e continuo a richiederla
	# Uso l'operatore -o per la OR tra le 2 espressioni
	# Uso lo standard output del comando grep dato della seconda espressione
	# Per il comando grep uso l'opzione -c per contare le righe che contengono la matricola dello studente grazie all'opzione -w nel file studenti.txt
	# E uso l'opzione -i per ignorare la differenza tra MAIUSCOLO e minuscolo
	# Come operatore di confronto nella seconda espressione uso -gt per restituire true se l'operando1 è > dell'operando2
	while [ "$matricola" = "" -o $(cat studenti.txt | cut -d ";" -f 3 | grep -c -i -w "$matricola" studenti.txt) -gt 0 ]
	do
		echo -e "ERRORE: matricola inserita vuota oppure già presente"
		echo -e "Inserire matricola:"
		read matricola
	done

	# ANNO
	echo -e "Inserire anno:"
	# Leggo l'anno accademico
	read anno
	
	# Finché l'anno inserito è uguale ad una stringa vuota oppure è minore ad 1 o maggiore di 3 segnalo un errore e continuo a richiederlo
	# Uso l'operatore -o per la OR tra le 3 espressioni
	# Uso l'operatore $(()) per la valutazione aritmetica della variabile stringa anno
	# Come operatore di confronto nella seconda espressione uso -lt per restituire true se l'operando1 è < dell'operando2
	# Come operatore di confronto nella seconda espressione uso -gt per restituire true se l'operando1 è > dell'operando2
	while [ "$anno" = "" -o $((anno)) -lt 1 -o $((anno)) -gt 3 ]
	do
		echo -e "ERRORE: anno inserito vuoto oppure non valido"
		echo -e "Inserire anno:"
		read anno
	done
	
	# Uso il comando >> per lo standard output stampando nel file studenti.txt i dati dello studente
	# Se non esiste il file studenti.txt con il comando >> lo creo vuoto
	# Uso il formato CSV nome <nome>;<cognome>;<matricola>;<anno> (<> esclusi)
	echo "$nome;$cognome;$matricola;$anno" >> studenti.txt
	
	clear
	
	# Segnalo che lo studente è stato inserito correttamente
	echo "Studente inserito correttamente"

	# INIT: eseguo la funzione init per ristampare il menu e richiedere un input da tastiera per la selezione di una voce del menu
	# Questa nel programma verrà eseguita alla fine delle funzioni relative alle voci del menu
	init
}

# 2. ELIMINA: funzione per eliminare uno studente dal file studenti.txt con l'inserimento della matricola
function elimina {
	echo -e "2. ELIMINA"
	echo -e "Inserire matricola: \c"
	read matricola
	clear
	
	# Con il comando grep cerco nel file studenti.txt se è presente uno studente in base alla sua matricola
	# Utilizzo l'output di grep come dato e lo memorizzo nella variabile presenti
	# Per il comando grep uso l'opzione -c per contare le righe che contengono la matricola dello studente che cerco con l'opzione -w
	# E uso l'opzione -i per ignorare la differenza tra MAIUSCOLO e minuscolo
	presenti=$(cat studenti.txt | grep -c -i -w "$matricola");
	
	# Accedo alla variabile presenti come valore aritmetico con l'operatore $(())
	# E se l'intero presenti è > 0 allora elimino lo studente (o gli studenti se più con la stessa matricola) perché presente nel file studenti.txt
	if [ $((presenti)) -gt 0 ]; then
	
		# Uso l'editor di riga sed per cancellare la riga di testo in studenti.txt corrispondente allo studente cercato
		# Per la ricerca della riga (o righe) corretta uso l'espressione regolare /.*;.*;$matricola;.*/d
		# \d sta per delete
		sed -i "/.*;.*;$matricola;.*/d" studenti.txt
		
		echo "Studente eliminato correttamente"
	else
		echo "ERRORE: studente non presente"
	fi
	init
}

# 3. MOSTRA: funzione per mostrare tutti gli studenti registrati nel file studenti.txt ordinati per matricola crescente
function mostra {
	clear

	# Nella variabile presenti memorizzo il numero di studenti registrati contando le righe del file studenti.txt
	# Con il comando cat stampo come output il contenuto del file studenti.txt
	# Leggo l'output del comando cat come input del comando wc e con l'opzione -l conto le righe dell'output
	# Utilizzo l'output di wc come dato all'interno di un altro comando e lo memorizzo nella variabile presenti
	presenti=$(cat studenti.txt | wc -l)

	# Accedo alla variabile presenti come valore aritmetico con l'operatore $(())
	# E se l'intero presenti è > 0 allora ordino e stampo gli studenti registrati nel file studenti.txt in base al loro numero di matricola crescente
	if [ $((presenti)) -gt 0 ]; then
	
		# Con il comando sort ordino gli studenti registrati in studenti.txt in base al loro numero di matricola crescente
		# Uso l'opzione -n per confrontare le stringhe di cifre in modo numerico
		# Uso l'opzione -t con parametro ";" per considerare il ; come separatore di campi
		# Uso l'opzione -k con parametro 3 per considerare il terzo campo del CSV relativo agli studenti
		# Uso l'opzione -o con parametro il file studenti.txt per scrivere i dati da ordinare nello stesso file
		sort studenti.txt -n -t ";" -k 3 -o studenti.txt
		
		echo -e "3. MOSTRA ELENCO"
		echo -e "NOME COGNOME MATRICOLA ANNO"

		# Con il comando cut e tr stampo tutti gli studenti registrati in studenti.txt
		# Con il comando cut seleziono tutti i campi per riga del CSV relativo allo studente
		# Uso l'opzione -t con parametro ";" per considerare il ; come separatore di campi
		# Uso l'opzione -f con parametro 1-4 per selezionare tutti i campi di ogni riga del file studenti.txt
		# Utilizzo l'output del comando cut come input per il comando tr
		# Con il comando tr sostituisco il separatore ; con uno spazio vuoto per delimitare i campi
		cut -d ";" -f 1-4 studenti.txt | tr ";" " "
		
	else
		# Segnalo che non è registrato nessuno studente nel file studenti.txt
		echo "ERRORE: Nessuno studente presente"
	fi
	init
}

# 4. RICERCA: funzione per la ricerca e la stampa sulla shell di uno (o più studenti) in base al suo cognome
function ricerca {
	echo -e "4. RICERCA"

	# Chiedo di inserire un cognome di uno studente
	echo -e "Inserisci un cognome: \c"

	# Leggo il cognome inserito dall'utente
	read cognome
	
	clear

	# In presenti memorizzo il numero degli studenti aventi lo stesso cognome di quello inserito dall'utente
	# Con il comando cat stampo come output il file studenti.txt e lo utilizzo come input per il cut
	# Uso il comando cut con l'opzione -d e il parametro ";" per considerare il secondo campo del CSV dello studente cioè il cognome con l'opzione -f e il parametro 2
	# Uso il comando grep per cercare nel file studenti.txt se è presente uno studente in base ad un cognome
	# Uso l'opzione -c per contare le righe del file studenti.txt che contengono un cognome uguale a quello inserito dall'utente
	# E uso l'opzione -i per ignorare la differenza tra MAIUSCOLO e minuscolo
	# Memorizzo come stringa il valore intero restituito dai 3 comandi concatenati appena citati in una variabile che ho chiamato presenti
	presenti=$(cat studenti.txt | cut -d ";" -f 2 | grep -c -i -w "$cognome" )

	# Se sono stati trovati degli studenti registrati con lo stesso cognome inserito dall'utente allora li stampo
	# Accedo alla variabile presenti come valore aritmetico con l'operatore $(())
	# Se presenti è maggiore di 0 allora entro nel blocco delle istruzioni dell'if 
	if [ $((presenti)) -gt 0 ]; then

		# Con il comando cat stampo come output il file studenti.txt e lo utilizzo come input per il comando sort
		# Con il comando sort ordino in modo crescente le righe del file studenti.txt
		# Uso l'opzione -d per considerare solo i caratteri vuoti e alfanumerici
		# Uso l'opzione -t con parametro ";" per dividere in campi le righe del file studenti.txt grazie al carattere separatore ;
		# Uso l'opzione -k con parametro 1 per ordinare crescentemente le righe del file studenti.txt in base al primo campo ovvero il nome
		# Con il successivo comando grep considero come input il file studenti.txt con gli studenti ordinati per cognome e ignorando la differenza tra minuscolo e MAIUSCOLO dei caratteri grazie all'opzione -i prendo solo le righe contenenti il cognome
		# Poi considero gli studenti selezionati con lo stesso cognome inserito dall'utente e con il comando cut li divido in campi grazie all'opzione -d con parametro ";" per indicare il carattere separatore delle singole righe e con l'opzione -f con parametro 1-4 considero tutti i campi di ogni studente selezionato
		# Infine per una formattazione degli studenti più informativa con i comandi sed aggiungo prima di ogni campo di ogni studente una stringa per descrivere il tipo di dato relativo allo studente
		# Nell'espressione regolare dei comandi sed utilizzo il carattere s per indicare che per ogni campo specificato sostituisco l'inizio della riga grazie al carattere ^ con una stringa informativa per il relativo campo da stampare
		#
		# Nome: xxxxx
		# Cognome: xxxxx
		# Matricola: xxxxx
		# Anno: xxxxx
		#
		# Nome: xxxxx
		# ...etc
		cat studenti.txt | sort -d -t ";" -k 1 | grep -i ".*;$cognome;.*" | cut -d ";" -f 1-4 | sed "s/^/\nNome: /" | sed "s/;/\nCognome: /" | sed "s/;/\nMatricola: /" | sed "s/;/\nAnno: /"
		
	else
		# Segnalo che la ricerca non è andata a buon fine poiché lo studente cercato per cognome non è presente
		echo "ERRORE: studente non presente"
	fi
	init
}

# 5. ISCRITTI: stampa sulla shell il numero degli studenti registrati nel file studenti.txt per anno
function iscritti {
	echo -e "5. ISCRITTI PER ANNO"

	# Uso \c per NON andare a capo
	# Uso il comando grep con l'opzione -c per contare le righe del file studenti.txt in cui è presente alla fine della riga il corrispettivo anno di iscrizione grazie al carattere $
	
	echo -e "Primo anno: \c"
	grep -c "1$" studenti.txt
	
	echo -e "Secondo anno: \c"
	grep -c "2$" studenti.txt
	
	echo -e "Terzo anno: \c"
	grep -c "3$" studenti.txt
	
	init
}

# 6. CONTROLLA: funzione che stampa sulla shell gli studenti registrati in studenti.txt con matricole non valide
# Con matricole non valide si intende matricole con un numero di cifre diverso da 6 
function controlla {
	echo -e "6. CONTROLLA MATRICOLE (ERRATE)"

	# Nella variabile presenti memorizzo il numero di studenti registrati contando le righe del file studenti.txt
	# Con il comando cat stampo come output il contenuto del file studenti.txt 
	# Leggo l'output del comando cat come input del comando wc e con l'opzione -l conto le righe dell'output
	# Utilizzo l'output di wc come dato all'interno di un altro comando e lo memorizzo nella variabile presenti
	presenti=$(cat studenti.txt | wc -l)

	# Se è presente almeno uno studente procedo con il controllo delle matricole
	# Accedo alla variabile presenti come valore aritmetico con l'operatore $(())
	# E se l'intero presenti è > 0 allora vuol dire che sono stati registrati degli studenti nel file studenti.txt con matricola non valida
	if [ $(($presenti)) -gt 0 ]; then

		# Nella variabile errate memorizzo il numero di matricole errate degli studenti registrati
		# Con l'opzione -v inverto il senso della ricerca cioè seleziono solo le righe relative agli studenti che non corrispondono per il pattern del comando grep
		# Uso -c per solo contare le righe del file studenti.txt
		# Uso "[0-9][0-9][0-9][0-9][0-9][0-9]" come pattern per considerare solo le matricole degli studenti aventi 6 cifre ognuna compresa tra 0 e 9
		errate=$(grep -v -c "[0-9][0-9][0-9][0-9][0-9][0-9]" studenti.txt)

		# Se il numero di matricole non valide è > di 0 allora...
		if [ $(($errate)) -gt 0 ]; then
			echo "NOME COGNOME MATRICOLA ANNO";

			# ...con il comando grep seleziono le matricole non valide e formatto l'output con il comando tr
			# Con il comando tr sostituisco il separatore ; con uno spazio vuoto per delimitare i campi
			grep -v "[0-9][0-9][0-9][0-9][0-9][0-9]" studenti.txt | tr ";" " ";
		else
			# Tutte le matricole sono valide
			echo "Matricole errate assenti";
		fi
	else
		# Nessuno studente presente
		echo "Nessuna matricola presente";
	fi
	init
}

# Pulisco lo schermo della shell prima di eseguire il programma
clear

# Creo il file studenti.txt nella directory corrente se non esiste altrimenti aggiorno la sua data di accesso e modifica con la data corrente 
file

# Inizio del programma
init
