#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>


 typedef struct  {
   int ID;
   int Direccion;
   int Estado;
   int Lista[1000];	
   int Contador;
   char **matriz;
}Informacion;

int column = 0;
int row = 0;
char **matriz;
int contadorhilos = 0; 
pthread_mutex_t semaforo = PTHREAD_MUTEX_INITIALIZER;

pthread_mutex_t contador = PTHREAD_MUTEX_INITIALIZER;

int LeerArchivo(){
	FILE *filepointer;
	int character,counter;

	filepointer=fopen("prueba1.txt", "r"); /* filepointer points to data.txt */
	if (filepointer==NULL) 
		{ /* error opening file returns NULL */
		printf("Could not open data.txt!\n"); /* error message */
		return 1; /* exit with failure */
	}
	while ((character=fgetc(filepointer)) != EOF) {
		if(character!= '\n')
		{
			counter++;
		}
		else
		{
			column = counter;
			counter = 0;
			row++;
		}
		
	//putchar(character); /* print the character */
	}
	//printf("Columnas : %d \n",column);
	//printf("Filas : %d \n",row);
	int i;
	matriz = (char **)malloc (row*sizeof(char *));
	for (i=0;i<row;i++)
	matriz[i] = (char *) malloc (column*sizeof(char));
	rewind(filepointer);
	i = 0;
	int j = 0;

	while ((character=fgetc(filepointer)) != EOF){
	
		if(character != '\n')
		{
			matriz[i][j] = character;
			j++;
		}
		else
		{
			i++;
			j = 0;
		}
	}

	/*for(i=0;i<row;i++)
		{
		for(j=0;j<column;j++)
			{
			putchar(matriz[i][j]);
		}
		printf("\n");
		}*/
	fclose(filepointer);
	return 0; /* close the file */
	}

void *corre_laberinto(void *ptr){
	
	Informacion *Info;
	Info = (Informacion *) ptr;
	//printf("Info : %d \n",Info->ID);
	
	int bandera;
	bandera = 0; 
	
    while (bandera != 1) {
	
	// Hace backup para el ciclo	
	Informacion Backup;
	Backup.ID =  Info->ID;
	Backup.Direccion =Info->Direccion;
	Backup.Estado = Info->Estado;
	int temp = 0; 
	while (Info->Contador >= temp){
		Backup.Lista[temp] = Info->Lista[temp];
		temp ++;
		Backup.Lista[temp] = Info->Lista[temp];
		temp ++;
		}
	Backup.Contador =Info->Contador;
	
/*----------------------------------------------	DIRECCION DERECHA ---------------------------------------------*/		
	/*Analiza si la direccion es derecha para seguir sin crear un hilo nuevo*/
	
	/*Analiza si ya visito el punto a analizar */ 
	
	int varcuenta = 0;
	int permiso = 1;
    while (varcuenta <= Backup.Contador){
		if (Backup.Lista[Backup.Contador]  != column - 1)	{	
		        if ( Backup.Lista[varcuenta] == Backup.Lista[Backup.Contador - 1]){
			       if ( Backup.Lista[varcuenta+1] == Backup.Lista[Backup.Contador] + 1){	
				   permiso = 0;		
				   varcuenta = 10000;		 	  
				   }				   
				   
		      } 
    	}
    	  	
    	if (Backup.Lista[Backup.Contador]  == column - 1 ) {
				   permiso = 0;		
				   varcuenta = 10000;		 	  
    	}  
    	
    	if (Backup.Lista[Backup.Contador]  == column - 1) {
			if (Backup.Direccion  == 0){
				   permiso = 0;		
				   varcuenta = 10000;
				   bandera=1;
			       // Imprime el resultado final del hilo
			       int numtemp2 = 0;
					pthread_mutex_lock(&semaforo);
					//sleep(0.5);
					printf("Info : %d \n",Info->ID);
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
						}
					}
					int i;
					int j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);	
			
		
					} 	  
    	} 		
       
		varcuenta ++;	
		varcuenta ++;
    }
	
	if (permiso == 1){     
		 
	if (Backup.Direccion == 0){ 
		/* Analiza si hay una pared a la derecha*/  
		if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] + 1] == '/' )   {
					  printf("----Hilo con Solucion----");
				  }
		 		
		if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] + 1] == ' ' )   {
			/* Mete la nueva ubicacion del hilo en la lista*/
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2];
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2] + 1;
			
		}
		else {
			bandera=1;
			// Imprime el resultado final del hilo
			int numtemp2 = 0;
					pthread_mutex_lock(&semaforo);
					//sleep(0.5);
					printf("Info : %d \n",Info->ID);
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
					{
						Info->matriz[i][j] = 'X';
					}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);
					
		
		}
	}
	/*Analiza si se puede seguir a la derecha y no tiene esa direccion, se crea hilo nuevo*/
	else{

	if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] + 1] == ' ' ||
		          matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] + 1] == '/')   {
					if (Info->Direccion != 0){										
					   if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
						[ Backup.Lista[Backup.Contador] + 1] == '/') {
							printf("----Hilo con Solucion----");							
							}	
					   pthread_mutex_lock(&contador);
					   int Lista2[1000];
					  char **matrizX;
					   Informacion nuevo = { contadorhilos,0,1,Lista2,0,matrizX };
					   int i,j;
					   nuevo.matriz = (char **)malloc (row*sizeof(char *));
					  for (i=0;i<row;i++)
					  nuevo.matriz[i] = (char *) malloc (column*sizeof(char));
					  for(i=0;i<row;i++)
						{
						for(j=0;j<column;j++)
						{
							nuevo.matriz[i][j] = matriz[i][j];
							}
						}
					   contadorhilos++; 
					   int temp = 0; 
					   while (Backup.Contador >= temp){
							nuevo.Lista[temp] = Backup.Lista[temp];
							temp ++;
							nuevo.Lista[temp] = Backup.Lista[temp];
							temp ++;
							}
						nuevo.Lista[temp] = nuevo.Lista[temp - 2] ;
						temp ++;
						nuevo.Lista[temp] = nuevo.Lista[temp - 2] + 1;
						temp ++;
					   nuevo.Contador = temp - 1; 
					   //    Crea el hilo nuevo	
					   pthread_t hilo;
					   pthread_create(&hilo, NULL, corre_laberinto, (void *)&nuevo);
					   sleep(1);
					   pthread_mutex_unlock(&contador); 
						
												
					}					
					}
	
		}
	}	
			
/*----------------------------------------------------	DIRECCION ABAJO --------------------------------------------------------*/		
	
	/* Pregunta si ya paso por el punto a analizar */
	varcuenta = 0;
	permiso = 1;
	while (varcuenta <= Backup.Contador){
		if (Backup.Lista[Backup.Contador - 1]  != row - 1)	{	
		        if ( Backup.Lista[varcuenta] == Backup.Lista[Backup.Contador - 1] + 1){
			       if ( Backup.Lista[varcuenta+1] == Backup.Lista[Backup.Contador]){	
				   permiso = 0;		
				   varcuenta = 10000;		 	  
				   }				   
				   
		      } 
    	}
    	  	
    	if (Backup.Lista[Backup.Contador - 1]  == row - 1 ) {
				   permiso = 0;		
				   varcuenta = 10000;		 	  
    	}  
    	
    	if (Backup.Lista[Backup.Contador - 1]  == row - 1) {
			if (Backup.Direccion  == 1){
				   permiso = 0;		
				   varcuenta = 10000;
				   bandera=1;
			// Imprime el resultado final del hilo
			int numtemp2 = 0;
					pthread_mutex_lock(&semaforo);
					//sleep(0.5);
					printf("Info : %d \n",Info->ID);
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
						}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);			} 	  
    	} 		
       
		varcuenta ++;	
		varcuenta ++;
    } 
	
	if (permiso == 1){ 
	
	/*Analiza si la direccion es abajo para seguir sin crear un hilo nuevo*/
	if (Backup.Direccion == 1){
		if ( ( matriz[ Backup.Lista[Backup.Contador - 1] + 1]
		          [ Backup.Lista[Backup.Contador ]] == '/' )   )   {
					  printf("----Hilo con Solucion----");
				  } 
		/* Analiza si hay una pared abajo */   		
		if ( ( matriz[ Backup.Lista[Backup.Contador - 1] + 1]
		          [ Backup.Lista[Backup.Contador ]] == ' ' )   )   {
			/* Mete la nueva ubicacion del hilo en la lista*/
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2] + 1;
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2];
		}
		else {
			bandera=1;
			// Imprime el resultado final del hilo
					pthread_mutex_lock(&semaforo);
					printf("Info : %d \n",Info->ID);
					int numtemp2 = 0;
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
					}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);
				

				
			    }
			
	    }
	
	/* En caso que la direccion no sea abajo, entonces se analiza si se puede crear
	 * un nuevo hilo en esa direccion*/
	 else{
	
	if ( matriz[ Backup.Lista[Backup.Contador - 1] + 1]
		          [ Backup.Lista[Backup.Contador ]] == ' ' ||
		          matriz[ Backup.Lista[Backup.Contador - 1] + 1]
		          [ Backup.Lista[Backup.Contador ]] == '/')   {
	        //	  Crea el struct del hilo nuevo
	       if (Info->Direccion != 1){	
	       if (  matriz[ Backup.Lista[Backup.Contador - 1] + 1]
		          [ Backup.Lista[Backup.Contador ]] == '/')   { 
	           printf("-----Hilo con Solucion----");
	   	   }
		   pthread_mutex_lock(&contador);
		   int Lista2[1000];
		   char **matrizX;
		   Informacion nuevo = { contadorhilos,1,1,Lista2,0,matrizX };
		   int i,j;
		   nuevo.matriz = (char **)malloc (row*sizeof(char *));
		   for (i=0;i<row;i++)
		   nuevo.matriz[i] = (char *) malloc (column*sizeof(char));
		   for(i=0;i<row;i++)
			{
			for(j=0;j<column;j++)
				{
				nuevo.matriz[i][j] = matriz[i][j];
						}
				}
	       contadorhilos++; 
	       int temp = 0; 
		   while (Backup.Contador >= temp){
				nuevo.Lista[temp] = Backup.Lista[temp];
				temp ++;
				nuevo.Lista[temp] = Backup.Lista[temp];
				temp ++;
				}
			nuevo.Lista[temp] = nuevo.Lista[temp - 2] + 1;
			temp ++;
			nuevo.Lista[temp] = nuevo.Lista[temp - 2] ;
			temp ++;
		   nuevo.Contador = temp - 1; 
           //    Crea el hilo nuevo	
           pthread_t hilo;
   	       pthread_create(&hilo, NULL, corre_laberinto, (void *)&nuevo);
   	       sleep(1);
   	       pthread_mutex_unlock(&contador); }
   	       
				}
			}
		}
		
		
/*----------------------------------------------------	DIRECCION ARRIBA --------------------------------------------------------*/		
	
	/* Pregunta si ya paso por el punto a analizar */
	varcuenta = 0;
	permiso = 1;
		
    while (varcuenta <= Backup.Contador){
		if (Backup.Lista[Backup.Contador - 1]  != 0)	{	
		        if ( Backup.Lista[varcuenta] == Backup.Lista[Backup.Contador - 1] - 1){
			       if ( Backup.Lista[varcuenta+1] == Backup.Lista[Backup.Contador]){	
				   permiso = 0;		
				   varcuenta = 10000;		 	  
				   }				   
				   
		      } 
    	}
    	  	
    	if (Backup.Lista[Backup.Contador - 1]  == 0) {
				   permiso = 0;		
				   varcuenta = 10000;		 	  
    	}  
    	
    	if (Backup.Lista[Backup.Contador - 1]  == 0) {
			if (Backup.Direccion  == 3){
				   permiso = 0;		
				   varcuenta = 10000;
				   bandera=1;
			// Imprime el resultado final del hilo
			int numtemp2 = 0;
					pthread_mutex_lock(&semaforo);
					//sleep(0.5);
					printf("Info : %d \n",Info->ID);
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
						}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);
				
			} 	  
    	} 		
       
		varcuenta ++;	
		varcuenta ++;
    } 
    
	if (permiso == 1){ 
	
	/*Analiza si la direccion es arriba para seguir sin crear un hilo nuevo*/
	if (Backup.Direccion == 3){ 
		if ( ( matriz[ Backup.Lista[Backup.Contador - 1] - 1]
		          [ Backup.Lista[Backup.Contador ]] == '/' )   )   {
					  printf("----Hilo con Solucion----");
				  } 
		/* Analiza si hay una pared abajo */   		
		if ( ( matriz[ Backup.Lista[Backup.Contador - 1] - 1]
		          [ Backup.Lista[Backup.Contador ]] == ' ' )   )   {
			/* Mete la nueva ubicacion del hilo en la lista*/
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2] - 1;
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2];
		}
		else {
			bandera=1;
			// Imprime el resultado final del hilo
					pthread_mutex_lock(&semaforo);
					printf("Info : %d \n",Info->ID);
					int numtemp2 = 0;
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
					}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);
			

				
			    }
			
	    }
	
	/* En caso que la direccion no sea arriba, entonces se analiza si se puede crear
	 * un nuevo hilo en esa direccion*/
	 
	else {
	if ( matriz[ Backup.Lista[Backup.Contador - 1] - 1]
		          [ Backup.Lista[Backup.Contador ]] == ' ' || 
		          matriz[ Backup.Lista[Backup.Contador - 1] - 1]
		          [ Backup.Lista[Backup.Contador ]] == '/')   {
	        //	  Crea el struct del hilo nuevo
	       if (Info->Direccion != 3){	
	       if (  matriz[ Backup.Lista[Backup.Contador - 1] - 1]
		          [ Backup.Lista[Backup.Contador ]] == '/') {
					  printf("-----Hilo con Solucion----");
				  }
		   pthread_mutex_lock(&contador);
		   int Lista2[1000];
		   char **matrizX;
		   Informacion nuevo = { contadorhilos,3,1,Lista2,0,matrizX };
		   int i,j;
		   nuevo.matriz = (char **)malloc (row*sizeof(char *));
           for (i=0;i<row;i++)
		   nuevo.matriz[i] = (char *) malloc (column*sizeof(char));
		   for(i=0;i<row;i++)
			{
			for(j=0;j<column;j++)
				{
			nuevo.matriz[i][j] = matriz[i][j];
						}
			}
	       contadorhilos++; 
	       int temp = 0; 
		   while (Backup.Contador >= temp){
				nuevo.Lista[temp] = Backup.Lista[temp];
				temp ++;
				nuevo.Lista[temp] = Backup.Lista[temp];
				temp ++;
				}
			nuevo.Lista[temp] = nuevo.Lista[temp - 2] - 1;
			temp ++;
			nuevo.Lista[temp] = nuevo.Lista[temp - 2] ;
			temp ++;
		   nuevo.Contador = temp - 1; 
           //    Crea el hilo nuevo	
           pthread_t hilo;
   	       pthread_create(&hilo, NULL, corre_laberinto, (void *)&nuevo);
   	       sleep(1);
   	       pthread_mutex_unlock(&contador);} 
   	       
				}
			}
		}

/*----------------------------------------------	DIRECCION IZQUIERDA ---------------------------------------------*/		
	/*Analiza si la direccion es derecha para seguir sin crear un hilo nuevo*/
	
	/*Analiza si ya visito el punto a analizar */ 
	
	varcuenta = 0;
	permiso = 1;
    while (varcuenta <= Backup.Contador){
		if (Backup.Lista[Backup.Contador]  != 0)	{	
		        if ( Backup.Lista[varcuenta] == Backup.Lista[Backup.Contador - 1]){
			       if ( Backup.Lista[varcuenta+1] == Backup.Lista[Backup.Contador] - 1){	
				   permiso = 0;		
				   varcuenta = 10000;		 	  
				   }				   
				   
		      } 
    	}
    	  	
    	if (Backup.Lista[Backup.Contador]  == 0) {
				   permiso = 0;		
				   varcuenta = 10000;		 	  
    	}  
    	
    	if (Backup.Lista[Backup.Contador]  == 0) {
			if (Backup.Direccion  == 2){
				   permiso = 0;		
				   varcuenta = 10000;
				   bandera=1;
			       // Imprime el resultado final del hilo
			       int numtemp2 = 0;
					pthread_mutex_lock(&semaforo);
					printf("Info : %d \n",Info->ID);
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
						}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);
			

			} 	  
    	} 		
       
		varcuenta ++;	
		varcuenta ++;
    }
	
	if (permiso == 1){     
		 
	if (Backup.Direccion == 2){ 
		/* Analiza si hay una pared a la derecha*/  
		if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] - 1] == '/' )   {
					  printf("----Hilo con Solucion----");
				  } 
		 		
		if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] - 1] == ' ' )   {
			/* Mete la nueva ubicacion del hilo en la lista*/
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2];
			Info->Contador ++;
			Info->Lista[(Info->Contador)] = Info->Lista[Info->Contador - 2] - 1;
			
		}
		else {
			bandera=1;
			// Imprime el resultado final del hilo
			int numtemp2 = 0;
					pthread_mutex_lock(&semaforo);
					printf("Info : %d \n",Info->ID);
					while (Info->Contador >= numtemp2 ){
						int i =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						int j =(int) Info->Lista[numtemp2];
						//printf("%d\n",Info->Lista[numtemp2]);
						numtemp2 ++;
						if(Info->matriz[i][j] != '/')
						{
						Info->matriz[i][j] = 'X';
						}
					}
					int i,j;
					for(i=0;i<row;i++)
					{
						for(j=0;j<column;j++)
						{
						putchar(Info->matriz[i][j]);
						}
						printf("\n");
						}
					pthread_mutex_unlock(&semaforo);	
		
	
		}
	}
	/*Analiza si se puede seguir a la derecha y no tiene esa direccion, se crea hilo nuevo*/
	else{

	if ( matriz[ Backup.Lista[Backup.Contador - 1] ]
		          [ Backup.Lista[Backup.Contador] - 1] == ' ' 
		          || matriz[ Backup.Lista[Backup.Contador - 1] ]
		             [ Backup.Lista[Backup.Contador] - 1] == '/')   {
					
					if (Info->Direccion != 2){	
						if (  matriz[ Backup.Lista[Backup.Contador - 1] ]
		                [ Backup.Lista[Backup.Contador] - 1] == '/'){
							printf("---Hilo con Solucion---");
							} 										
					   pthread_mutex_lock(&contador);
					   int Lista2[1000];
					  char **matrizX;
					   Informacion nuevo = { contadorhilos,2,1,Lista2,0,matrizX };
					   int i,j;
					   nuevo.matriz = (char **)malloc (row*sizeof(char *));
					  for (i=0;i<row;i++)
					  nuevo.matriz[i] = (char *) malloc (column*sizeof(char));
					  for(i=0;i<row;i++)
						{
						for(j=0;j<column;j++)
							{
						nuevo.matriz[i][j] = matriz[i][j];
							}
						}
					   contadorhilos++; 
					   int temp = 0; 
					   while (Backup.Contador >= temp){
							nuevo.Lista[temp] = Backup.Lista[temp];
							temp ++;
							nuevo.Lista[temp] = Backup.Lista[temp];
							temp ++;
							}
						nuevo.Lista[temp] = nuevo.Lista[temp - 2] ;
						temp ++;
						nuevo.Lista[temp] = nuevo.Lista[temp - 2] - 1;
						temp ++;
					   nuevo.Contador = temp - 1; 
					   //    Crea el hilo nuevo	
					   pthread_t hilo;
					   pthread_create(&hilo, NULL, corre_laberinto, (void *)&nuevo);
					   sleep(1);
					   pthread_mutex_unlock(&contador); 
						
												
					}					
					}
	
}
	}	
   
    }
}

int main(){
	LeerArchivo();
	int Lista2[1000];
	char **matrizX;
	Informacion primero = {contadorhilos,0,1,Lista2,0, matrizX};
	int i,j;
	primero.matriz = (char **)malloc (row*sizeof(char *));
	for (i=0;i<row;i++)
	primero.matriz[i] = (char *) malloc (column*sizeof(char));
	for(i=0;i<row;i++)
		{
	for(j=0;j<column;j++)
	{
	primero.matriz[i][j] = matriz[i][j];
						}
	}
	pthread_mutex_lock(&contador);
	contadorhilos++;
	pthread_mutex_unlock(&contador);
	primero.Lista[0] = 0;
	primero.Lista[1] = 0;
	primero.Contador = 1;
	pthread_t hilo;
	pthread_create(&hilo, NULL, corre_laberinto, (void *)&primero);
	sleep(20);
	return 0;
	}
