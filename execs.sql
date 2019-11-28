DROP TABLE IF EXISTS `execs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `execs` (
  `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `username` varchar(255) default NULL,
  `cmd` varchar(65530) default NULL,
  `user` varchar(255) default NULL,
  `pid` INT NOT NULL,
  `env` varchar(4096) default NULL,
  `time` varchar(128) default NULL,
  `cwd` varchar(128) default  NULL,
  `exit_code` INT default NULL,
  `started_ts` timestamp NOT NULL default now(),
  `ended_ts` timestamp NULL,
  `line` varchar(65530) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
