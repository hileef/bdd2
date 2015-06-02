SET FEEDBACK OFF
SET LINESIZE 150
SET PAGESIZE 40

ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy';

REM ***************************************************************************
REM APPLICATION BANCAIRE
REM Auteur : HAUTEFEUILLE Eliot
REM Date de Mise à Jour : 01/06/2015
REM ***************************************************************************
PROMPT -- APPLICATION BANCAIRE - Eliot Hautefeuille

REM ************************************************
PROMPT -- (INIT 1/4) Nettoyage BDD

drop table Banque 			cascade constraints purge ;
drop table AuditDecouvert 	cascade constraints purge ;
drop table TypeCompte 		cascade constraints purge ;
drop table Operation 		cascade constraints purge ;
drop table Compte 			cascade constraints purge ;

drop sequence seq_compte	;
drop sequence seq_operation	;
drop sequence seq_type		;
drop sequence seq_banque	;
drop sequence seq_audit		;

REM ************************************************
PROMPT -- (INIT 2/4) Creation des tables BDD

create table Banque (
	idBanque			integer 	 											 ,
	libelleBanque		varchar(50)		constraint nn_banque_libelle	not null ,
	cpbBanque			char(5)			constraint nn_banque_cp 		not null ,
	addresseBanque		varchar(50) 	constraint nn_banque_addr		not null ,
	villeBanque			varchar(30) 	constraint nn_banque_ville		not null
) ;

create table AuditDecouvert (
	idAudit				integer 	 											 ,
	idCompte			integer			constraint nn_audit_dec_compte	not null ,
	libelleCompte		varchar(30) 	constraint nn_audit_libelle		not null ,
	soldeCompte			number(10,2)	constraint nn_audit_solde 		not null ,
	decouvertAutorise	number(10,2)	constraint nn_audit_decouvert 	not null ,
	depassement			number(10,2)	constraint nn_audit_depassemnt 	not null ,
	idDerniereOperation	integer			constraint nn_audit_dern_oper	not null
) ;

create table TypeCompte (
	idType		integer													 ,
	libelleTypeCompte	varchar(30)		constraint nn_type_libelle		not null
) ;

create table Operation (
	idOperation 		integer													 ,
	idCompte 			integer			constraint nn_oper_compte		not null ,
	dateOperation		date  default sysdate 	constraint nn_oper_date	not null ,
	montantOperation	number(10,2)	constraint nn_oper_montant		not null
) ;

create table Compte (
	idCompte 			integer													 ,
	idBanque			integer			constraint nn_commpte_banque	not null ,
	idType 				integer			constraint nn_commpte_type		not null ,
	libelleCompte 		varchar(30)		constraint nn_compte_libelle	not null ,
	soldeCompte 	number(10,2) default 0 constraint nn_compte_solde 	not null ,
	decouvertAutorise number(10,2) default 0 constraint nn_compte_dcvrt	not null ,
	dateOuvertureCompte	date default sysdate constraint nn_compte_date	not null
) ;

REM ************************************************
PROMPT -- (INIT 3/4) Ajout des contraintes

alter table Banque
	add constraint 	pk_banque			primary key	(idBanque)
	add constraint 	u_banque_libelle	unique		(libelleBanque) ;

alter table AuditDecouvert
	add constraint 	pk_audit_decouvert	primary key	(idAudit) ;

alter table TypeCompte
	add constraint 	pk_type_compte		primary key	(idType) ;

alter table Compte
	add constraint 	pk_compte 			primary key (idCompte)
	add constraint 	fk_compte_banque	foreign key (idBanque)
			references 	Banque(idBanque)			on delete set null
	add constraint 	fk_compte_type		foreign key (idType)
			references 	TypeCompte(idType) 	on delete set null ;

alter table Operation
	add constraint 	pk_operation		primary key	(idOperation)
	add constraint 	fk_operation_compte	foreign key (idCompte)
			references 	Compte(idCompte) 	on delete set null ;

REM ************************************************
PROMPT -- (INIT 4/4) Generation Sequences

create sequence seq_banque		start with 99 nocache ;
create sequence seq_type 		start with 199 nocache ;
create sequence seq_audit 		start with 399 nocache ;
create sequence seq_compte 		start with 999 nocache ;
create sequence seq_operation 	start with 4999 nocache ;


REM ************************************************
PROMPT -- (FIXTURES) Remplissage jeu de donnees de test

PROMPT -- ..TypeCompte [3]
insert into TypeCompte(idType, libelleTypeCompte)
	values(seq_type.nextval, 'Cheque') ;
insert into TypeCompte(idType, libelleTypeCompte)
	values(seq_type.nextval, 'Epargne') ;
insert into TypeCompte(idType, libelleTypeCompte)
	values(seq_type.nextval, 'Assurance Vie') ;

PROMPT -- ..Banque [3]
insert into Banque(idBanque, libelleBanque, cpbBanque, villeBanque, addresseBanque)
	values(seq_banque.nextval, 'BNP Parisbas', '75016', 'Paris', 'Av Haussman');
insert into Banque(idBanque, libelleBanque, cpbBanque, villeBanque, addresseBanque)
	values(seq_banque.nextval, 'Societe Generale', '92800', 'La Defense', '[7]');
insert into Banque(idBanque, libelleBanque, cpbBanque, villeBanque, addresseBanque)
	values(seq_banque.nextval, 'Banque Postale', '75006', 'Paris', 'Montparnasse');

PROMPT -- ..Compte [9]
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 100, 200, 'Eliot Hautefeuille');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 100, 201, 'Eliot Hautefeuille');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 100, 202, 'Eliot Hautefeuille');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 101, 200, 'Wang Tu');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 101, 201, 'Wang Tu');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 101, 202, 'Wang Tu');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 102, 200, 'Kevin Keovilay');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 102, 201, 'Kevin Keovilay');
insert into Compte(idCompte, idBanque, idType, libelleCompte)
	values(seq_compte.nextval, 102, 202, 'Kevin Keovilay');

PROMPT -- ..Operation [9]
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1000, 1320);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1001, 200);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1002, 7850);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1003, 221);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1004, 15600);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1005, 6530);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1006, 23);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1007, 164);
insert into Operation(idOperation, idCompte, montantOperation)
	values(seq_operation.nextval, 1008, 1752);

PROMPT -- ..AuditDecouvert [0]

REM ************************************************
PROMPT -- (DONE) Script termine.
