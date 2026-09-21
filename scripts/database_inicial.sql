/*
Plataforma Utilizada: Sql Server Managemnet Studio 2022 
O que ela gerará quando rodada:
  -Criação do banco de dados DataWarehouse
  -Criação dos esquemas Bronze, Prata e Ouro

CUIDADO: O código não funcionará caso já exista um server já existente de mesmo nome, nesse caso, só altere o nome da base de dados 
*/

--Criação da base de dados DataWarehouse

USE master;

 CREATE DATABASE DataWarehouse; --Se já existir uma base com esse nome, altere nessa parte

 USE DataWarehouse;

 CREATE SCHEMA Bronze;
 GO
 CREATE SCHEMA Prata;
 GO
 CREATE SCHEMA Ouro;
 GO
