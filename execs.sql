DROP TABLE IF EXISTS `execs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `execs` (
  `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `json` varchar(12096) default NULL,
  `json_end` varchar(8096) default NULL,
  `exec` varchar(255) default NULL,
  `cgroup` varchar(255) default NULL,
  `cgroup_max_mem_bytes` INT default NULL,
  `cgroup_cpuacct_usage` INT default NULL,
  `cgroup_match` varchar(255) default NULL,
  `cgroup_json` varchar(4096) default NULL,
  `exec_name` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `cmd` MEDIUMTEXT NOT NULL,
  `_cmd` MEDIUMTEXT NOT NULL,
  `_args` MEDIUMTEXT NOT NULL,
  `pid` INT NOT NULL,
  `env` varchar(4096) default NULL,
  `cwd` varchar(128) default  NULL,
  `exit_code` INT default NULL,
  `line` MEDIUMTEXT NOT NULL,
  `time` varchar(128) default NULL,
  `time_ms` INT default NULL;
  `started_ts` timestamp NOT NULL default now(),
  `ended_ts` timestamp NULL,
  `line_b64` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
