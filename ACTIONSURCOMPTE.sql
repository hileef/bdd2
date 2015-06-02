REM ***************************************************************************
REM APPLICATION BANCAIRE - PROCEDURES
REM Auteur : HAUTEFEUILLE Eliot
REM Date de Mise à Jour : 01/06/2015
REM ***************************************************************************
PROMPT -- APPLICATION BANCAIRE - PROCEDURES - Eliot Hautefeuille



REM ************************************************
PROMPT -- (PROC) ajoutNouvOperation(idCompte, montant)
create or replace procedure ajoutNouvOperation (idc integer, val number) is
begin

	insert into operation(idOperation, idCompte, montantOperation)
		values(seq_operation.nextval, idc, val);

end ;
/


REM ************************************************
PROMPT -- (PROC) annulerOperation(idOperation)
create or replace procedure annulerOperation (ido integer)
is
	val number(10,2) ;
	idc integer ;
begin
	
	select idCompte, montantOperation into idc, val
	from operation where idOperation = ido ;
	insert into operation(idOperation, idCompte, montantOperation)
		values(seq_operation.nextval, idc, -val);

end ;
/

REM ************************************************
PROMPT -- (PROC) majDecouvertAutorise(idCompte, value)
create or replace procedure majDecouvertAutorise (idc integer, val number) is
begin
	
	update compte set decouvertAutorise = val where idCompte = idc ;

end ;
/


REM ************************************************
PROMPT -- (PROC) majMontantOperation(idOperation, value)
create or replace procedure majMontantOperation (ido integer, val number) is
begin
	
	update operation set montantOperation = val where idOperation = ido ;

end ;
/


REM ************************************************
PROMPT -- (PROC) faireTransfertCompte(ori, dest, value)
create or replace procedure majMontantOperation (
								ori integer, dest integer, val number) is
begin
	
	ajoutNouvOperation(ori, -val);
	ajoutNouvOperation(dest, val);

end ;
/


REM ************************************************
PROMPT -- (PROC) banqueOperation(idOperation) : varchar
create or replace function banqueOperation (ido integer) return varchar 
is
	nom varchar(50) ;
begin

	select libelleBanque into nom from Banque b, Compte c, Operation o
	where b.idBanque = c.idBanque and c.idCompte = o.idCompte
	and o.idOperation = ido ;
	
	return nom ;

end ;
/


REM ************************************************
PROMPT -- (PROC) soldeCompte(idCompte) : number
create or replace function soldeCompte (idc integer) return number
is
	solde number(10,2) ;
begin

	select soldeCompte into solde from Compte where idCompte = idc ;
	
	return solde ;

end ;
/
