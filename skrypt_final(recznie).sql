DROP DATABASE IF EXISTS Firma_Transportowa
GO

CREATE DATABASE Firma_Transportowa;
GO

USE [Firma_Transportowa]
GO

CREATE TABLE Kierowca (
id_kierowcy int not null Identity(1,1) PRIMARY KEY,
imie varchar(25) not null,
nazwisko varchar(100) not null,
data_ur date,
pesel int not null,
kod_pocztowy varchar(6) not null,
miasto varchar(50) not null,
ulica varchar(50) not null,
nr_domu varchar(7) not null,
nr_lokalu varchar(5),
telefon varchar(15) not null,
mail varchar(50) not null,
)
GO

CREATE TABLE Klient (
id_klienta int not null Identity(1,1) PRIMARY KEY,
imie varchar(25) not null,
nazwisko varchar(100) not null,
data_ur date,
pesel int not null,
nip varchar(10) not null,
kod_pocztowy varchar(6) not null,
miasto varchar(50) not null,
ulica varchar(50) not null,
nr_domu varchar(7) not null,
nr_lokalu varchar(5),
telefon varchar(15) not null,
mail varchar(50) not null,
)
GO

CREATE TABLE Ubezpieczenie (
nr_polisy varchar(30) not null PRIMARY KEY,
data_rozpocz�cia_ubezpieczenia date not null,
data_zako�czenia_ubezpieczenia date not null,
sk�adka money not null,
op�acone bit not null,
)
GO

CREATE TABLE �adunek (
id_�adunku int not null Identity(1,1) PRIMARY KEY,
masa_�adunku int not null,
d�ugo�� int,
rodzaj varchar(100) not null,
)
GO

CREATE TABLE Pojazd (
id_pojazdu int not null Identity(1,1) PRIMARY KEY,
model varchar(20) not null,
marka varchar(20) not null,
nr_rejestracyjny varchar(10) not null,
rok_produkcji date not null,
nr_vin varchar(25) not null,
przebieg int not null,
rodzaj_pojazdu varchar(20) CHECK (rodzaj_pojazdu IN('2-osiowy','3-osiowy','lekki')) not null,
emisja_spalin varchar(10) CHECK (emisja_spalin IN('euro1', 'euro2', 'euro3','euro4','euro5','euro6')) NOT NULL,
fk_nr_polisy varchar(30)  FOREIGN KEY REFERENCES Ubezpieczenie(nr_polisy),
fk_id_przyczepy int FOREIGN KEY REFERENCES [dbo].[Przyczepa]([id_przyczepy]),
)
GO

CREATE TABLE Przyczepa (
id_przyczepy int not null Identity(1,1) PRIMARY KEY,
nr_rejestracyjny varchar(10) not null,
�adowno�� int not null,
wysoko�� int not null,
d�ugo�� int not null,
fk_id_pojazdu int FOREIGN KEY REFERENCES Pojazd(id_pojazdu),
fk_nr_polisy varchar(30)  FOREIGN KEY REFERENCES Ubezpieczenie(nr_polisy),
)
GO


CREATE TABLE Trasa (
id_trasy int not null Identity(1,1) PRIMARY KEY,
miejsce_za�adunku varchar(30) not null,
miejsca_roz�adunku varchar(30) not null,
d�ugo��_trasy int not null,
fk_id_klient int not null FOREIGN KEY REFERENCES Klient(id_klienta),
fk_id_kierowcy int not null FOREIGN KEY REFERENCES Kierowca(id_kierowcy),
fk_id_�adunku int not null FOREIGN KEY REFERENCES �adunek(id_�adunku),
fk_id_przyczepy int not null FOREIGN KEY REFERENCES [dbo].[Przyczepa]([id_przyczepy]),
fk_id_pojazdu int not null FOREIGN KEY REFERENCES [dbo].[Pojazd]([id_pojazdu]),
)
GO




-------PROCEDURY---------
--dodawania klienta--


CREATE OR ALTER PROC dodawanie_klienta	
	@nazwa_firmy varchar(30) ,
	@imie varchar(25) ,
	@nazwisko varchar(100),
	@nip varchar(10),
	@kod_pocztowy varchar(6) ,
	@miasto varchar(50) ,
	@ulica varchar(50) ,
	@nr_domu varchar(7) ,
	@nr_lokalu varchar(5) ,
	@telefon varchar(15) ,
	@mail varchar(50) 
AS

DECLARE @error AS NVARCHAR(200);

IF  
	@kod_pocztowy IS NULL OR 
	@miasto IS NULL OR 
	@ulica IS NULL OR 
	@nr_domu IS NULL OR 
	@telefon IS NULL OR 
	@mail IS NULL 

BEGIN
     SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
     RAISERROR(@error, 16,1);
     RETURN;
END

INSERT INTO [dbo].[Klient]
           ([nazwa_firmy]
           ,[imie]
           ,[nazwisko]
           ,[nip]
           ,[kod_pocztowy]
           ,[miasto]
           ,[ulica]
           ,[nr_domu]
           ,[nr_lokalu]
           ,[telefon]
           ,[mail])
     VALUES
           (@nazwa_firmy  ,
			@imie  ,
			@nazwisko ,
			@nip ,
			@kod_pocztowy  ,
			@miasto ,
			@ulica  ,
			@nr_domu  ,
			@nr_lokalu  ,
			@telefon  ,
			@mail )


--SELECT * FROM [dbo].[Klient] WHERE (id_klienta = @@IDENTITY)
GO

--EXEC dodawanie_klienta
--			@nazwa_firmy= 'MirTrans' ,
--			@imie = 'Mirek' ,
--			@nazwisko ='Nowak',
--			@nip =7687656545,
--			@kod_pocztowy =98288 ,
--			@miasto='Warszawa' ,
--			@ulica ='��dzka' ,
--			@nr_domu =42 ,
--			@nr_lokalu =3 ,
--			@telefon  =432534765,
--			@mail='test@mail.pl'
--GO
--dodawanie kierowcy--

CREATE OR ALTER PROC dodawanie_kierowcy	
		    @imie varchar(25)
           ,@nazwisko varchar(100)
           ,@data_ur date
           ,@pesel varchar(11)
           ,@kod_pocztowy varchar(6)
           ,@miasto varchar(50)
           ,@ulica varchar(50)
           ,@nr_domu varchar(7)
           ,@nr_lokalu varchar(5)
           ,@telefon varchar(15)
           ,@mail varchar(50)
AS

DECLARE @error AS NVARCHAR(200);

IF		@imie IS NULL OR
           @nazwisko  IS NULL OR      
           @pesel IS NULL OR
           @kod_pocztowy IS NULL OR
           @miasto IS NULL OR
           @ulica IS NULL OR
           @nr_domu   IS NULL OR    
           @telefon IS NULL OR
           @mail IS NULL 

BEGIN
     SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
     RAISERROR(@error, 16,1);
     RETURN;
END

INSERT INTO [dbo].[Kierowca]
           ([imie]
           ,[nazwisko]
           ,[data_ur]
           ,[pesel]
           ,[kod_pocztowy]
           ,[miasto]
           ,[ulica]
           ,[nr_domu]
           ,[nr_lokalu]
           ,[telefon]
           ,[mail])
     VALUES
           (@imie 
           ,@nazwisko 
           ,@data_ur 
           ,@pesel 
           ,@kod_pocztowy 
           ,@miasto 
           ,@ulica
		   ,@nr_domu 
           ,@nr_lokalu
           ,@telefon 
           ,@mail )



--SELECT * FROM [dbo].[Kierowca] WHERE ([id_kierowcy] = @@IDENTITY)
GO

--EXEC dodawanie_kierowcy
--			@imie ='Arek'
--           ,@nazwisko ='Dusigrosz'		 
--           ,@data_ur = '1983-03-03'
--           ,@pesel = 83030371376
--           ,@kod_pocztowy = '77-077'
--           ,@miasto ='Sosnowiec'
--           ,@ulica ='pi�kna'
--		   ,@nr_domu = 23
--           ,@nr_lokalu = 77
--           ,@telefon =698765432
--           ,@mail='bremutoarek@wp.pl'
--GO

--dodanie przyczepy--

CREATE OR ALTER PROC dodawanie_przyczepy	
		   @nr_rejestracyjny varchar(10),
		   @nr_vin varchar(25),
           @�adowno�� int,
           @wysoko�� int,
           @d�ugo�� int,
           @fk_id_pojazdu int,
           @fk_nr_polisy varchar(30)
AS

DECLARE @error AS NVARCHAR(200);

IF	       @nr_rejestracyjny IS NULL OR
           @�adowno�� IS NULL OR
           @wysoko�� IS NULL OR
           @d�ugo�� IS NULL OR
			@nr_vin is NULL

BEGIN
     SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
     RAISERROR(@error, 16,1);
     RETURN;
END

INSERT INTO [dbo].[Przyczepa]
           ([nr_rejestracyjny]
		   ,[nr_vin]
           ,[�adowno��]
           ,[wysoko��]
           ,[d�ugo��]
           ,[fk_id_pojazdu]
           ,[fk_nr_polisy])
     VALUES
           (@nr_rejestracyjny,
		   @nr_vin,
           @�adowno�� ,
           @wysoko�� ,
           @d�ugo�� ,
           @fk_id_pojazdu,
           @fk_nr_polisy )



--SELECT * FROM  [dbo].[Przyczepa] WHERE ( [id_przyczepy]= @@IDENTITY)
GO

--EXEC dodawanie_przyczepy
--		   @nr_rejestracyjny ='EL DF321',
--           @�adowno�� = 9,
--           @wysoko�� =370,
--           @d�ugo�� =520,
--           @fk_id_pojazdu =2,
--           @fk_nr_polisy = '83873765'
--GO


----------Procedura dodania �adunku------------
CREATE OR ALTER  PROC [dbo].[dodawanie_�adunku]
    @masa_�adunku int ,
    @d�ugo�� int,
    @rodzaj varchar(100)

AS

DECLARE @error AS NVARCHAR(200);

IF  
    @masa_�adunku IS NULL OR 
    @rodzaj IS NULL


BEGIN
     SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
     RAISERROR(@error, 16,1);
     RETURN;
END

INSERT INTO [dbo].[�adunek]
           ([masa_�adunku]
           ,[d�ugo��]
           ,[rodzaj])

     VALUES(@masa_�adunku,
            @d�ugo�� ,
            @rodzaj )



--SELECT * FROM [dbo].[�adunek] WHERE (id_�adunku = @@IDENTITY)
GO


----------Procedura dodania pojazdu------------
CREATE  OR ALTER PROC [dbo].[dodawanie_pojazdu]
    @model varchar(20) ,
    @marka varchar(20),
    @nr_rejestracyjny varchar(10),
    @rok_produkcji date,
    @nr_vin varchar(25),
    @przebieg int,
    @rodzaj_pojazdu varchar(20),
    @emisja_spalin varchar(10),
    @fk_nr_polisy varchar(30),
	@fk_id_przyczepy int
AS

DECLARE @error AS NVARCHAR(200);

IF   
    @model is null or
    @marka is null or
    @nr_rejestracyjny is null or
    @rok_produkcji is null or
    @nr_vin is null or
    @przebieg is null or
    @rodzaj_pojazdu is null or
    @emisja_spalin is null 
   



BEGIN
     SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
     RAISERROR(@error, 16,1);
     RETURN;
END





BEGIN 
	IF EXISTS (SELECT nr_rejestracyjny,nr_vin FROM [dbo].[Pojazd] WHERE nr_rejestracyjny=@nr_rejestracyjny OR nr_vin=@nr_vin) 
			BEGIN
				PRINT 'Pojazd o podanym numerze vin lub rejestracji istnieje'
				SELECT * FROM [dbo].[Pojazd] WHERE nr_rejestracyjny=@nr_rejestracyjny OR nr_vin=@nr_vin
			END
		ELSE
			BEGIN 
				INSERT INTO [dbo].[Pojazd]
			   ([model],
			   [marka],
			   [nr_rejestracyjny],
			   [rok_produkcji],
			   [nr_vin],
			   [przebieg],
			   [rodzaj_pojazdu],
			   [emisja_spalin],
			   [fk_nr_polisy],
			   [fk_id_przyczepy])

		 VALUES
			   (@model  ,
				@marka ,
				@nr_rejestracyjny,
				@rok_produkcji,
				@nr_vin,
				@przebieg,
				@rodzaj_pojazdu,
				@emisja_spalin,
				@fk_nr_polisy,
				@fk_id_przyczepy)
				PRINT 'Dodano pomy�lnie pojazd'
			END
END

			
--SELECT * FROM [dbo].[Pojazd] WHERE (id_pojazdu = @@IDENTITY)
GO

EXEC dodawanie_pojazdu 
	@model ='R450' ,
    @marka ='SCANIA',
    @nr_rejestracyjny ='EL 1233',
    @rok_produkcji ='2018-02-01',
    @nr_vin ='32384934AD32',
    @przebieg =432213,
    @rodzaj_pojazdu ='3-osiowy',
    @emisja_spalin ='euro6',
    @fk_nr_polisy ='5435324',
	@fk_id_przyczepy=null
	GO


--dodawanie trasy--
CREATE OR ALTER PROCEDURE dodawanie_trasy
            @miejsce_za�adunku varchar(50),
            @miejsca_roz�adunku varchar(50),
            @dlugosc_trasy int,
            @klient int,
            @kierowca int,
            @�adunek int,
            @przyczepa int,
            @pojazd int
AS
DECLARE @error AS varchar(50);

    IF  @miejsce_za�adunku IS NULL OR
        @miejsca_roz�adunku IS NULL OR
        @dlugosc_trasy IS NULL OR
        @klient IS NULL OR
        @kierowca IS NULL OR
        @�adunek IS NULL OR
        @przyczepa IS NULL OR
        @pojazd IS NULL
        BEGIN
            SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
            RAISERROR(@error , 16, 1);
            RETURN;
        END
INSERT INTO [dbo].[Trasa]
            ([miejsce_za�adunku],
            [miejsca_roz�adunku],
            [d�ugo��_trasy],
            [fk_id_klient],
            [fk_id_kierowcy],
            [fk_id_�adunku],
            [fk_id_przyczepy],
            [fk_id_pojazdu])
VALUES
            (@miejsce_za�adunku,
            @miejsca_roz�adunku,
            @dlugosc_trasy,
            @klient,
            @kierowca,
            @�adunek,
            @przyczepa,
            @pojazd)
--SELECT * FROM [dbo].[Trasa] WHERE ([id_trasy] = @@IDENTITY);
GO

--dodawanie ubezpieczenia--
CREATE OR ALTER PROCEDURE dodawanie_ubezpieczenia
@nr_polisy varchar(30),
@data_rozpocz�cia_ubezpieczenia date,
@data_zako�czenia_ubezpieczenia date,
@sk�adka money,
@op�acone bit
AS
    DECLARE @error AS varchar(50);
    IF @nr_polisy IS NULL OR
        @data_rozpocz�cia_ubezpieczenia IS NULL OR
        @data_zako�czenia_ubezpieczenia IS NULL OR
        @sk�adka IS NULL OR
        @op�acone IS NULL
        BEGIN
        SET @error = 'Pr�ba wprowadzenia nieprawid�owych danych!';
        RAISERROR(@error, 21,1);
        END
INSERT INTO [dbo].[Ubezpieczenie](
            [nr_polisy],
            [data_rozpocz�cia_ubezpieczenia],
            [data_zako�czenia_ubezpieczenia],
            [sk�adka],
            [op�acone])
VALUES
            (@nr_polisy ,
            @data_rozpocz�cia_ubezpieczenia ,
            @data_zako�czenia_ubezpieczenia ,
            @sk�adka ,
            @op�acone )

--SELECT * FROM [dbo].[Ubezpieczenie] WHERE (nr_polisy = @@IDENTITY);
GO


--procedura wy�wietlenie ile dni do konca ubezpieczenia--

CREATE OR ALTER PROC do_ko�ca_ubezpieczenia_pozosta�o_dni
@nr_polisy varchar(50)
    AS
	BEGIN
    
	
	IF(SELECT DATEDIFF(day, GETDATE(),[data_zako�czenia_ubezpieczenia]) AS do_ko�ca_ubezpieczenia_pozosta�o_dni
	FROM [dbo].[Ubezpieczenie] WHERE (nr_polisy = @nr_polisy) )< 0
		BEGIN
			PRINT 'Up�yna� czas ubezpieczenia'
		END
		ELSE
		BEGIN
			SELECT DATEDIFF(day, GETDATE(),[data_zako�czenia_ubezpieczenia]) AS do_ko�ca_ubezpieczenia_pozosta�o_dni
			FROM [dbo].[Ubezpieczenie] WHERE (nr_polisy = @nr_polisy)
		END
	END
GO


CREATE OR ALTER PROC pokaz_nieoplacone_ubezpieczenia
AS
SELECT * FROM [dbo].[Ubezpieczenie] AS nieop�acone_ubezpieczenia WHERE [op�acone] = 0
GO

--procedura dodawania polisy do pojazdu
CREATE OR ALTER PROC dodanie_polisy_do_pojazdu
	@nr_polisy varchar(30), 
	@nr_rejestracyjny varchar(10)

	AS
	BEGIN
	UPDATE [dbo].[Pojazd]
		SET [fk_nr_polisy]=@nr_polisy
		WHERE [nr_rejestracyjny]=@nr_rejestracyjny

		PRINT 'Doda�e� nr polisy:' + @nr_polisy + ' do pojazdu o numerze:' + @nr_rejestracyjny; 
	END
GO

--procedura dodawania polisy do przyczepy
CREATE OR ALTER PROC dodanie_polisy_do_przyczepy
	@nr_polisy varchar(30), 
	@nr_rejestracyjny varchar(10)

	AS
	BEGIN
	UPDATE [dbo].[Przyczepa]
		SET [fk_nr_polisy]=@nr_polisy
		WHERE [nr_rejestracyjny]=@nr_rejestracyjny

		PRINT 'Doda�e� nr polisy:' + @nr_polisy + ' do pojazdu o numerze:' + @nr_rejestracyjny; 
	END
GO

--update danych Kierowcy z mo�liwo�ci� edycji pojedynczych danych--
CREATE OR ALTER PROC update_Kierowcy
            @id_kierowcy_aktualizowanego int
           ,@imie varchar(25) = null
           ,@nazwisko varchar(100) = null
           ,@data_ur date = null
           ,@pesel varchar(11) = null
           ,@kod_pocztowy varchar(6) = null
           ,@miasto varchar(50) = null
           ,@ulica varchar(50) = null
           ,@nr_domu varchar(7) = null
           ,@nr_lokalu varchar(5) = null
           ,@telefon varchar(15) = null
           ,@mail varchar(50) = null
AS
BEGIN
    UPDATE [dbo].[Kierowca]
   SET [imie] = isNull(@imie,imie)
      ,[nazwisko] = isNull(@nazwisko,nazwisko)
      ,[data_ur] = isNull(@data_ur,data_ur)
      ,[pesel] = isNull(@pesel,pesel)
      ,[kod_pocztowy] = isNull(@kod_pocztowy,kod_pocztowy)
      ,[miasto] =isNull(@miasto,miasto)
      ,[ulica] = isNull(@ulica,ulica)
      ,[nr_domu] = isNull(@nr_domu,nr_domu)
      ,[nr_lokalu] =isNull(@nr_lokalu,nr_lokalu)
      ,[telefon] = isNull(@telefon,telefon)
      ,[mail] = isNull(@mail,mail)
 WHERE id_kierowcy = @id_kierowcy_aktualizowanego
END
GO

exec update_Kierowcy
	3,'Adam','Nowak','1970-04-04',70404324,'98-288','Warszawa','sieradzka',10,null,543654234,'adam@wpl.pl'
	GO
--update danych klienta z mo�liwo�ci� edycji pojedynczych danych--
CREATE OR ALTER PROC update_klienta
        @id_klienta_aktualizowanego int,
        @nazwa_firmy varchar(30)= null ,
        @imie varchar(25) = null,
        @nazwisko varchar(100)= null,
        @nip varchar(10)= null,
        @kod_pocztowy varchar(6)= null ,
        @miasto varchar(50) = null,
        @ulica varchar(50)= null ,
        @nr_domu varchar(7) = null,
        @nr_lokalu varchar(5)= null ,
        @telefon varchar(15)= null ,
        @mail varchar(50) = null
AS
BEGIN
SET NOCOUNT ON
    UPDATE [dbo].[Klient]
   SET [nazwa_firmy] = isNull(@nazwa_firmy,nazwa_firmy)
      ,[imie] =isNull(@imie,imie)
      ,[nazwisko] = isNull(@nazwisko,nazwisko)
      ,[nip] = isNull(@nip,nip)
      ,[kod_pocztowy] = isNull(@kod_pocztowy,kod_pocztowy)
      ,[miasto] =isNull(@miasto,miasto)
      ,[ulica] = isNull(@ulica,ulica)
      ,[nr_domu] =isNull(@nr_domu,nr_domu)
      ,[nr_lokalu] = isNull(@nr_lokalu,nr_lokalu)
      ,[telefon] = isNull(@telefon,telefon)
      ,[mail] = isNull(@mail,mail)
 WHERE id_klienta=@id_klienta_aktualizowanego
END
GO

--update przyczepa z mo�liwo�ci� edycji pojedynczych danych--
CREATE OR ALTER PROC update_przyczepy
           @id_przyczepy_aktualizowanej int,
           @nr_rejestracyjny varchar(10) = null,
           @nr_vin varchar(25) = null,
           @�adowno�� int = null,
           @wysoko�� int = null,
           @d�ugo�� int = null,
           @fk_id_pojazdu int = null,
           @fk_nr_polisy varchar(30) = null
AS
BEGIN
SET NOCOUNT ON
    UPDATE [dbo].[Przyczepa]
   SET [nr_rejestracyjny] = isNull(@nr_rejestracyjny,nr_rejestracyjny)
      ,[�adowno��] = isNull(@�adowno��,�adowno��)
      ,[wysoko��] = isNull(@wysoko��, wysoko��)
      ,[d�ugo��] = isNull(@d�ugo��,d�ugo��)
      ,[fk_id_pojazdu] =isNull (@fk_id_pojazdu,fk_id_pojazdu)
      ,[fk_nr_polisy] =isNull (@fk_nr_polisy,fk_nr_polisy)
      ,[nr_vin] =isNull (@nr_vin, nr_vin)
 WHERE id_przyczepy=@id_przyczepy_aktualizowanej
END
GO



--udpate pojazdu z mo�liwo�ci� edycji pojedynczych danych--
CREATE OR ALTER PROC update_pojazdu
			@id_pojazdu_akutalizowanego int,
		    @model varchar(20) = null,
			@marka varchar(20)= null,
			@nr_rejestracyjny varchar(10)= null,
			@rok_produkcji date=null,
			@nr_vin varchar(25)=null,
			@przebieg int= null,
			@rodzaj_pojazdu varchar(20)= null,
			@emisja_spalin varchar(10)= null,
			@fk_nr_polisy varchar(30)= null,
			@fk_id_przyczepy int= null
AS
BEGIN
SET NOCOUNT ON
	UPDATE [dbo].[Pojazd]
   SET [model] =isNULL(@model,model)
      ,[marka] = isNULL(@marka,marka)
      ,[nr_rejestracyjny] =isNULL(@nr_rejestracyjny,nr_rejestracyjny)
      ,[rok_produkcji] =isNULL(@rok_produkcji,rok_produkcji)
      ,[nr_vin] =isNULL(@nr_vin,nr_vin)
      ,[przebieg] =isNULL(@przebieg,przebieg)
      ,[rodzaj_pojazdu] = isNULL(@rodzaj_pojazdu,rodzaj_pojazdu)
      ,[emisja_spalin] = isNULL(@emisja_spalin,emisja_spalin)
      ,[fk_nr_polisy] = isNULL(@fk_nr_polisy,fk_nr_polisy)
      ,[fk_id_przyczepy] = isNULL(@fk_id_przyczepy,fk_id_przyczepy)
 WHERE id_pojazdu = @id_pojazdu_akutalizowanego
END         
GO

--update �adunku z mo�liwo�ci� edycji pojedynczych danych--
 
CREATE OR ALTER PROC update_�adunku
		@id_�adunku_aktualizowanego int,
	   	@masa_�adunku int = NULL,
		 @d�ugo�� int = NULL,
		 @rodzaj varchar(100)= NULL
AS
BEGIN
SET NOCOUNT ON
	UPDATE [dbo].[�adunek]
	   SET [masa_�adunku] = isNULL(@masa_�adunku,masa_�adunku)
		  ,[d�ugo��] = isNULL(@d�ugo��,d�ugo��)
		  ,[rodzaj] = isNULL(@rodzaj,rodzaj)
	 WHERE id_�adunku=@id_�adunku_aktualizowanego
END         
GO

--update trasy z mo�liwo�ci� edycji pojedynczych danych--
CREATE OR ALTER PROC update_trasy
			@id_trasy_aktualizowanej int,
		    @miejsce_za�adunku varchar(50)= NULL,
            @miejsca_roz�adunku varchar(50)= NULL,
            @dlugosc_trasy int= NULL,
            @klient int= NULL,
            @kierowca int= NULL,
            @�adunek int= NULL,
            @przyczepa int= NULL,
            @pojazd int= NULL
AS
BEGIN
SET NOCOUNT ON
	UPDATE [dbo].[Trasa]
   SET [miejsce_za�adunku] = isNULL(@miejsce_za�adunku,miejsce_za�adunku)
      ,[miejsca_roz�adunku] =isNULL(@miejsca_roz�adunku,miejsca_roz�adunku)
      ,[d�ugo��_trasy] = isNULL(@dlugosc_trasy,d�ugo��_trasy)
      ,[fk_id_klient] = isNULL(@klient,fk_id_klient)
      ,[fk_id_kierowcy] =isNULL( @kierowca,fk_id_kierowcy)
      ,[fk_id_�adunku] = isNULL(@�adunek,fk_id_�adunku)
      ,[fk_id_przyczepy] = isNULL(@przyczepa,fk_id_przyczepy)
      ,[fk_id_pojazdu] =isNULL( @pojazd,fk_id_pojazdu)
 WHERE id_trasy=@id_trasy_aktualizowanej
END         
GO

--update ubezpieczenia z mo�liwo�ci� edycji pojedynczych danych--
CREATE OR ALTER PROC update_ubezpieczenia
        @nr_polisy varchar(30),
        @data_rozpocz�cia_ubezpieczenia date = null,
        @data_zako�czenia_ubezpieczenia date = null,
        @sk�adka money = null,
        @op�acone bit = null
AS
BEGIN
SET NOCOUNT ON
    UPDATE [dbo].[Ubezpieczenie]
   SET 
      [data_rozpocz�cia_ubezpieczenia] = isNull(@data_rozpocz�cia_ubezpieczenia,data_rozpocz�cia_ubezpieczenia)
      ,[data_zako�czenia_ubezpieczenia] = isNull(@data_zako�czenia_ubezpieczenia, data_zako�czenia_ubezpieczenia)
      ,[sk�adka] = isNull(@sk�adka,sk�adka)
      ,[op�acone] = isNull(@op�acone, op�acone)
 WHERE nr_polisy=@nr_polisy
END
GO

--delete kierowca--
CREATE OR ALTER PROC delete_kierowca
		@id_kierowcy_usuwanego int
	   	
AS
BEGIN
	DELETE FROM [dbo].[Kierowca]
      WHERE id_kierowcy= @id_kierowcy_usuwanego
	  PRINT 'Usuni�to rekord'
END         
GO

--delete klient--
CREATE OR ALTER PROC delete_klient
		@id_klient_usuwanego int
	   	
AS
BEGIN
	DELETE FROM [dbo].[Klient]
      WHERE id_klienta=@id_klient_usuwanego
	  PRINT 'Usuni�to rekord'
END         
GO

--delete �adunek--
CREATE OR ALTER PROC delete_�adunek
		@id_�adunek_usuwanego int
	   	
AS
BEGIN
	DELETE FROM [dbo].[�adunek]
      WHERE id_�adunku=@id_�adunek_usuwanego
	  PRINT 'Usuni�to rekord'
END         
GO

--delete pojazd--
CREATE OR ALTER PROC delete_pojazd
		@id_pojazdu_usuwanego int
	   	
AS
BEGIN
	DELETE FROM [dbo].[Pojazd]
      WHERE id_pojazdu=@id_pojazdu_usuwanego
	  PRINT 'Usuni�to rekord'
END         
GO
--delete przyczepa--
CREATE OR ALTER PROC delete_przyczepa
		@id_przyczepy_usuwanej int
	   	
AS
BEGIN
	DELETE FROM [dbo].[Przyczepa]
      WHERE id_przyczepy=@id_przyczepy_usuwanej
	  PRINT 'Usuni�to rekord'
END         
GO

--delete trasa--
CREATE OR ALTER PROC delete_trasy
		@id_trasy_usuwanej int
	   	
AS
BEGIN
	DELETE FROM [dbo].[Trasa]
      WHERE id_trasy=@id_trasy_usuwanej
	  PRINT 'Usuni�to rekord'
END         
GO

--delete ubezpieczenia--
CREATE OR ALTER PROC delete_ubezpieczenia
		@nr_polisy_usuwanej int
	   	
AS
BEGIN
	DELETE FROM [dbo].[Ubezpieczenie]
      WHERE nr_polisy=@nr_polisy_usuwanej
	  PRINT 'Usuni�to rekord'
END         
GO


--raport stan kierowc�w--
CREATE OR ALTER PROC raport_stan_kierowc�w

AS
BEGIN
DECLARE

	@ilo��_kierowc�w_zatrudnionych int = (SELECT COUNT(*) FROM [dbo].[Kierowca] ), 
	@ilo��_kierowc�w_w_trasie int =(SELECT COUNT(fk_id_kierowcy) FROM [dbo].[Trasa] WHERE fk_id_kierowcy is not null),
	@ilo��_kierowc�w_bez_trasy int =((SELECT COUNT(*) FROM [dbo].[Kierowca] )-(SELECT COUNT(fk_id_kierowcy) FROM [dbo].[Trasa] WHERE fk_id_kierowcy is not null))

	PRINT 'Ilo�� kierowc�w zatrudnionych wynosi: '+ CAST(@ilo��_kierowc�w_zatrudnionych AS varchar);
	PRINT 'Ilo�� kierowc�w w trasie wynosi: ' + 	CAST(@ilo��_kierowc�w_w_trasie AS varchar);
	PRINT 'Ilo�� kierowc�w bez wyznaczonej trasy wynosi: ' + 	CAST(@ilo��_kierowc�w_bez_trasy AS varchar);
END
GO


--raport polis dla pojazd�w i przyczep--
CREATE OR ALTER PROC raport_polis

AS
BEGIN
DECLARE
	@suma_sk�adek int = (select sum(sk�adka) from [dbo].[Ubezpieczenie])
	
	PRINT 'Raport polis dla przyczep' 
	select  nr_polisy,sk�adka,nr_rejestracyjny from [dbo].[Ubezpieczenie],[dbo].[Przyczepa] where nr_polisy=[dbo].[Przyczepa].fk_nr_polisy;
	PRINT 'Raport polis dla pojazd�w' 
	select  nr_polisy,sk�adka,nr_rejestracyjny from [dbo].[Ubezpieczenie],[dbo].[Pojazd] where nr_polisy=fk_nr_polisy ;
	PRINT 'Suma sk�adek wynosi: ' + CAST(@suma_sk�adek as varchar);
END
GO

--raport tras--
CREATE OR ALTER PROC raport_wykaz
AS
BEGIN

	SELECT [id_trasy],[miejsce_za�adunku],[miejsca_roz�adunku],[d�ugo��_trasy],nr_rejestracyjny,nazwa_firmy,[fk_id_�adunku],[dbo].[Kierowca].[imie],[dbo].[Kierowca].[nazwisko]
FROM [dbo].[Kierowca],[dbo].[Trasa],[dbo].[Klient],[dbo].[Pojazd] where fk_id_kierowcy=id_kierowcy AND fk_id_klient=id_klienta AND fk_id_pojazdu=id_pojazdu
	
END
GO

exec raport_wykaz
GO

--raport_klient_prywatny_czy_biznesowy
CREATE OR ALTER PROC raport_klient_prywatny_czy_biznesowy
AS
BEGIN
	SELECT * FROM [dbo].[Klient] WHERE nip is null OR nazwa_firmy is null
	PRINT 'Pierwsza tabela generuje raport o klientach prywatnych '
	SELECT * FROM [dbo].[Klient] WHERE nip is not null OR nazwa_firmy is not null
		PRINT 'Pierwsza tabela generuje raport o klientach biznesowych '
END
GO

--raport przyczep o podanych parametrach kt�re nie s� w trasie --
CREATE OR ALTER PROC raport_przyczep_o_danych_parametrach
	@�adowno�� int =null,
	@d�ugo�� int = null,
	@wysoko�� int = null
AS
BEGIN
SET NOCOUNT ON
	SELECT * FROM [dbo].[Przyczepa] WHERE (�adowno��>=isNULL(@�adowno��,�adowno��) AND d�ugo��>=isNULL(@d�ugo��,d�ugo��) AND wysoko��>=isNULL(@wysoko��,wysoko��)) 

END
GO

--raport  pojazd�w i przyczep w firmie--
CREATE OR ALTER PROC raport_pojazdy_przyczepy_w_firmie
AS
BEGIN
	SELECT * FROM [dbo].[Pojazd] 
	PRINT 'Pierwsza tabela prezentuje wykaz pojazd�w'
	SELECT * FROM [dbo].[Przyczepa]
	PRINT 'Druga tabela prezentuje wykaz przyczep'
	SELECT * FROM [dbo].[Pojazd],[dbo].[Przyczepa] WHERE [dbo].[Pojazd].fk_id_przyczepy=id_przyczepy AND fk_id_pojazdu=id_pojazdu
	PRINT 'Trzecia tabela prezentuje wykaz pojazd�w z przypisan� przyczep�'
END
GO


------trigger------
--trigger gratulacje po utworzeniu bazy--
CREATE OR ALTER TRIGGER [trgCreateDatabase] ON ALL SERVER
AFTER CREATE_DATABASE
AS 
BEGIN
PRINT 'Gratuluj� utworzenia nowej bazy!'
END
GO



CREATE OR ALTER TRIGGER [dodanie_wolnego_pojazdu_do_przyczepy] ON [dbo].[Przyczepa]
AFTER INSERT
AS 
BEGIN
	DECLARE
		@pojazd int = (select top (1) id_pojazdu from  [dbo].[Pojazd] where [dbo].[Pojazd].fk_id_przyczepy is null ),
		@przyczepa int = (select top (1) id_przyczepy from  [dbo].[Przyczepa] where [dbo].[Przyczepa].fk_id_pojazdu is null ),
		@rejestracja_przyczepy varchar(10) = (select nr_rejestracyjny from [dbo].[Przyczepa] where [dbo].[Przyczepa].[id_przyczepy]=(select top (1) id_przyczepy from  [dbo].[Przyczepa] where [dbo].[Przyczepa].fk_id_pojazdu is null )) ,
		@rejestracja_pojazdu varchar(10) = 	(select nr_rejestracyjny from [dbo].[Pojazd] where [dbo].[Pojazd].id_pojazdu=(select top (1) id_pojazdu from  [dbo].[Pojazd] where [dbo].[Pojazd].fk_id_przyczepy is null ))

		

		UPDATE [dbo].[Pojazd]
			   SET 
				 [fk_id_przyczepy] = @przyczepa
			WHERE id_pojazdu=@pojazd;

		 UPDATE [dbo].[Przyczepa]
				SET 
				 [fk_id_pojazdu] = @pojazd
				 WHERE id_przyczepy = @przyczepa
		
		IF @pojazd is null 
			BEGIN
				PRINT 'Brak pojazd�w bez przypisanej przyczepy!'
			END

PRINT 'Po��czy�e� przyczepe o numerach: ' + @rejestracja_przyczepy +' z pojazdem o numerach:' +   @rejestracja_pojazdu;
END
GO

CREATE OR ALTER TRIGGER wy�wietlenie_informacji_o_braku_polisy ON [dbo].[Pojazd]
	AFTER INSERT
AS
BEGIN
	DECLARE
	@id int = (select top(1) id_pojazdu  from [dbo].[Pojazd] where fk_id_przyczepy is null ORDER BY id_pojazdu DESC )
	--@id_pojazdu int = (select id_pojazdu from [dbo].[Pojazd] where [dbo].[Pojazd].id_pojazdu= AND [dbo].[Pojazd].fk_nr_polisy = null)
	IF (@id is not null)
	BEGIN
		PRINT 'Brak polisy.Nie mo�esz porusza� si� pojazdem bez polisy'
	END
END
GO

--exec dodawanie_pojazdu
-- 'TGX','MAN','GDA TEST12','2010-01-01','AS124324ASSD',732204,'3-osiowy','euro6',null,null
--aktulizacjia danych pomyslna trigger

--widok aktualny trasy
--aktulana flota
--pracownicy kto gdzie jak co robi

CREATE OR ALTER TRIGGER aktualizacja_danych_kierowcy ON [dbo].[Kierowca]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli Kierowcy'
	SELECT * FROM [dbo].[Kierowca] 
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER aktualizacja_danych_Klienta ON [dbo].[Klient]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli Klient'
	SELECT * FROM 	[dbo].[Klient]
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER aktualizacja_danych_�adunek ON [dbo].[�adunek]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli �adunek'
	SELECT * FROM [dbo].[�adunek]
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER aktualizacja_danych_pojazdu ON [dbo].[Pojazd]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli Pojazd'
	SELECT * FROM  [dbo].[Pojazd]
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER aktualizacja_danych_przyczepy ON [dbo].[Przyczepa]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli Przyczepa'
	SELECT * FROM [dbo].[Przyczepa]
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER aktualizacja_danych_trasy ON [dbo].[Trasa]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli Kierowcy'
	SELECT * FROM [dbo].[Trasa]
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER aktualizacja_danych_ubezpieczenia ON [dbo].[Ubezpieczenie]
	AFTER UPDATE 
AS
BEGIN
	PRINT 'Zaktualizowa�e� dane dla tabeli Ubezpieczenia'
	SELECT * FROM  [dbo].[Ubezpieczenie]
	SET NOCOUNT ON
END
GO

CREATE OR ALTER TRIGGER dodanie_klienta_bez_nr_lokalu ON [dbo].[Klient]
AFTER INSERT
AS
BEGIN
    DECLARE 
        @id int = (SELECT TOP(1) id_klienta FROM [dbo].[Klient] WHERE nr_lokalu is null ORDER BY id_klienta DESC)
    IF(@id is not null)
    BEGIN
        PRINT 'Upewnij si� �e podany adres jest prawid�owy, gdy� nie dodano numeru lokalu.'
    END
END
GO
