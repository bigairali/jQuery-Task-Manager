# ************************************************************
# Sequel Pro SQL dump
# Version 4004
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.9)
# Database: dossier_db
# Generation Time: 2013-02-12 05:01:46 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table clients
# ------------------------------------------------------------

DROP TABLE IF EXISTS `clients`;

CREATE TABLE `clients` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `clientName` char(128) DEFAULT NULL,
  `primaryContact` int(11) unsigned DEFAULT NULL,
  `phone` text,
  `address` char(128) DEFAULT NULL,
  `city` char(32) DEFAULT NULL,
  `state` char(32) DEFAULT NULL,
  `zipcode` mediumint(9) DEFAULT NULL,
  `website` text,
  `email` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;

INSERT INTO `clients` (`id`, `clientName`, `primaryContact`, `phone`, `address`, `city`, `state`, `zipcode`, `website`, `email`)
VALUES
	(1,'Full Sail University',5,'407-679-0100','3300 University Blvd','Orlando','FL',32828,'www.fullsail.edu',NULL),
	(2,'FakeCo',5,'555-555-5555','1234 Nowhere Ave.','Busytown','NY',13126,'www.fakeco.com',NULL),
	(3,'CodeInfused',5,'555-263-3387',NULL,NULL,NULL,32792,'www.codeinfused.com',NULL);

/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `projects`;

CREATE TABLE `projects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `clientID` int(11) unsigned DEFAULT NULL,
  `teamID` int(11) unsigned DEFAULT NULL,
  `projectName` text,
  `projectDescription` text,
  `updatedDate` char(32) DEFAULT NULL,
  `dueDate` char(32) DEFAULT NULL,
  `status` char(32) DEFAULT NULL,
  `startDate` char(32) DEFAULT NULL,
  `projectCreator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `teamID` (`teamID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;

INSERT INTO `projects` (`id`, `clientID`, `teamID`, `projectName`, `projectDescription`, `updatedDate`, `dueDate`, `status`, `startDate`, `projectCreator`)
VALUES
	(1,1,NULL,'Task Management App','Create a project manager as a rich web application, utilizing jQuery and server-side restful actions accessed via ajax.  Features incorporated should be UX-centric, following the functional specifications provided by the SFW2 contact.',NULL,NULL,'active',NULL,11),
	(2,1,NULL,'WFP Final Project','A project concept to be defined and executed with flawless precision and professionalism by the student with the help of Full Sail University\'s outstanding educational team.',NULL,NULL,'active',NULL,11),
	(3,3,NULL,'Learning JavaScript','Become a ninja with JavaScript.',NULL,NULL,'delayed',NULL,5),
	(4,2,NULL,'No Ones Project','This job is worked on by very scary testing ghosts who make sure that content is limited correctly.',NULL,NULL,'delayed',NULL,5),
	(27,NULL,NULL,'Student Test','This is an emergency test of the student project adding system for SFW2.',NULL,NULL,'active','Wed, 27 Jul 2011 00:17:05 GMT',11),
	(35,NULL,NULL,'Calendar Events',NULL,NULL,NULL,'active',NULL,22);

/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tasks`;

CREATE TABLE `tasks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `projectID` int(11) unsigned DEFAULT NULL,
  `taskeeID` int(11) unsigned DEFAULT NULL,
  `taskCreator` int(11) unsigned DEFAULT NULL,
  `taskName` text,
  `taskDescription` text,
  `specs` text,
  `status` char(32) DEFAULT 'active',
  `priority` int(32) unsigned DEFAULT NULL,
  `updatedDate` char(32) DEFAULT NULL,
  `dueDate` char(32) DEFAULT NULL,
  `startDate` char(32) DEFAULT NULL,
  `hourlyRate` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `projectID` (`projectID`),
  KEY `taskeeID` (`taskeeID`),
  KEY `creator` (`taskCreator`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;

INSERT INTO `tasks` (`id`, `projectID`, `taskeeID`, `taskCreator`, `taskName`, `taskDescription`, `specs`, `status`, `priority`, `updatedDate`, `dueDate`, `startDate`, `hourlyRate`)
VALUES
	(1,1,11,5,'Creative Brief','Prepare creative pitch for the client.  Due date is the client meeting and project kickoff.  Creative document needs:  feature specifications, wireframes, design compositions, style guide, project planning chart.',NULL,'active',1,NULL,NULL,NULL,NULL),
	(2,1,11,5,'Prototype','Develop the HTML and CSS prototype foundation of the project.  Goal is to ready all necessary HTML, CSS, and image elements before client side or server side development begins.',NULL,'active',2,NULL,NULL,NULL,NULL),
	(3,1,11,5,'Development Milestone','First major project milestone, as agreed on with client.  Functionality to have done:  user signup, user login and logout, template loading for landing page and application, initial dashboard content for application.',NULL,'active',3,NULL,NULL,NULL,NULL),
	(4,1,11,5,'Revisions','Revisit all functionality specifications originally planned, and determine current project status.  Schedule client meeting for any revision needs or scope changes before final product launch.',NULL,'active',4,NULL,NULL,NULL,NULL),
	(5,1,11,5,'Launch','Deploy application and remove beta access from live tests.  Hand off all assets to client per contract needs and finalize work.',NULL,'active',5,NULL,NULL,NULL,NULL),
	(6,2,11,5,'Brainstorm Final Project Concept','Before WFP begins, the student should come up with a few ideas for a final project that they would like to leave Full Sail with.  The final project is an opportunity to showcase design and development skills to the industry using whatever you are passionate about.  Get started early!',NULL,'active',1,NULL,NULL,NULL,NULL),
	(9,1,11,11,'Return Test',NULL,NULL,'active',NULL,NULL,NULL,NULL,NULL),
	(342,35,0,48,'Soccer Tryouts for Timmy','3:00pm Don\\\'t miss it!',NULL,'Urgent',NULL,NULL,NULL,'2013-January-30',NULL),
	(341,35,0,48,'Begin fitness','3 sets of 10 push ups and either walk around baldwin park or run.',NULL,'Normal',NULL,NULL,NULL,'2013-February-11',NULL),
	(339,35,0,48,'Temple in Tampa','Give thanks, get food, buy sticky rice... Enjoy',NULL,'Normal',NULL,NULL,NULL,'2013-February-10',NULL),
	(340,35,0,48,'Oil Change',NULL,NULL,'Finished',NULL,NULL,NULL,'2013-February-11',NULL),
	(338,35,0,48,'Renewal Lease offer expires',NULL,NULL,'Urgent',NULL,NULL,NULL,'2013-February-14',NULL),
	(337,35,0,48,'Family Arrives','Should come in this afternoon',NULL,'Normal',NULL,NULL,NULL,'2013-February-06',NULL),
	(336,35,0,48,'Last Day of class','Finally done',NULL,'Finished',NULL,NULL,NULL,'2013-February-01',NULL),
	(335,35,0,48,'Rehearsal','Rehearse for showcase',NULL,'Delayed',NULL,NULL,NULL,'2013-February-06',NULL),
	(333,35,0,48,'Graduation','2013 Full Sail Graduate',NULL,'Normal',NULL,NULL,NULL,'2013-February-08',NULL),
	(334,35,2013,48,'2013 Full Sail Showcase','Showcase for Final Project and my time at Full Sail',NULL,'Urgent',NULL,NULL,NULL,'2013-February-07',NULL),
	(331,35,0,47,'Soccer Game','Tigers VS Bears',NULL,'Normal',NULL,NULL,NULL,'2013-February-01',NULL),
	(332,35,0,47,'TPS Report Meeting','We have to remember to put covers on the TPS Reports. We will have a follow up later.',NULL,'Urgent',NULL,NULL,NULL,'2013-January-30',NULL),
	(330,35,0,46,'TPS Report Meeting','We have to remember to put covers on the TPS Reports. We will have a follow up later.',NULL,'Urgent',NULL,NULL,NULL,'2013-February-19',NULL),
	(329,35,0,46,'Begin Dieting',NULL,NULL,'Delayed',NULL,NULL,NULL,'2013-March-01',NULL),
	(328,35,0,46,'TPS Report Meeting','We have to remember to put covers on the TPS Reports. We will have a follow up later.',NULL,'Urgent',NULL,NULL,NULL,'2013-February-18',NULL),
	(327,35,0,46,'TPS Report Meeting','We have to remember to put covers on the TPS Reports. We will have a follow up later.',NULL,'Urgent',NULL,NULL,NULL,'2013-March-02',NULL),
	(319,35,0,43,'Meeting about TPS Reports','I need to remember to put a cover on them.',NULL,'Urgent',NULL,NULL,NULL,'2013-February-19',NULL),
	(320,35,0,43,'Cookout','Jim is having a get together',NULL,'Delayed',NULL,NULL,NULL,'2013-February-23',NULL),
	(321,35,0,44,'title',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-February-07',NULL),
	(322,35,0,44,'kjgh',NULL,NULL,'Delayed',NULL,NULL,NULL,'2013-January-09',NULL),
	(323,35,0,44,'tps report',NULL,NULL,'Urgent',NULL,NULL,NULL,'2013-March-07',NULL),
	(324,35,0,45,'Soccer Game','Spartans VS Tigers',NULL,'Normal',NULL,NULL,NULL,'2013-February-06',NULL),
	(325,35,0,45,'TPS Report Meeting','We have to remember to put covers on the TPS Reports. We will have a follow up later.',NULL,'Urgent',NULL,NULL,NULL,'2013-February-18',NULL),
	(304,35,0,39,'Things',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-January-09',NULL),
	(305,35,0,39,'Yeah!',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-January-02',NULL),
	(326,35,0,45,'Begin Weight-loss Plan',NULL,NULL,'Delayed',NULL,NULL,NULL,'2013-March-01',NULL),
	(303,35,0,39,'adsfa',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-January-02',NULL),
	(302,35,0,39,'Thanks',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-January-09',NULL),
	(301,35,0,39,'Thanks',NULL,NULL,'Normal',NULL,NULL,NULL,'2012-December-05',NULL),
	(317,35,0,43,'Phone Bill',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-February-14',NULL),
	(316,35,0,43,'Soccer Game','Finals against the Tigers',NULL,'Finished',NULL,NULL,NULL,'2013-February-07',NULL),
	(314,35,0,42,'Meeting on the TPS Reports',NULL,NULL,'Urgent',NULL,NULL,NULL,'2013-February-15',NULL),
	(315,35,0,42,'Pay phone bill','Any later and fees will pile up',NULL,'Urgent',NULL,NULL,NULL,'2013-February-21',NULL),
	(312,35,0,41,'What happened?','Be sure to remember to get eggs and bacon!',NULL,'Normal',NULL,NULL,NULL,'2013-February-15',NULL),
	(311,35,0,41,'Grocery shopping','Be sure to remember to get eggs and bacon!',NULL,'Finished',NULL,NULL,NULL,'2013-January-11',NULL),
	(309,35,0,40,'Things that go bump','This is a test of the things to do',NULL,'Urgent',NULL,NULL,NULL,'2013-January-04',NULL),
	(307,35,0,39,'This is a new event',NULL,NULL,'Delayed',NULL,NULL,NULL,'2013-January-02',NULL),
	(308,35,0,39,'waefaef',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-January-03',NULL),
	(306,35,0,39,'asdfasd',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-January-08',NULL),
	(343,35,0,49,'Things',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-February-06',NULL),
	(344,35,0,49,'adsfadsf',NULL,NULL,'Normal',NULL,NULL,NULL,'2013-February-03',NULL);

/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table teams
# ------------------------------------------------------------

DROP TABLE IF EXISTS `teams`;

CREATE TABLE `teams` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(128) DEFAULT NULL,
  `description` text,
  `website` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;

INSERT INTO `teams` (`id`, `name`, `description`, `website`)
VALUES
	(1,'Scripting For Web','This team out of the Full Sail University office in Orlando is focused on the development of projects for WDD instructors on the campus.  The team consists of 1 student.','http://www.fullsail.com');

/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `teamID` int(11) unsigned DEFAULT NULL,
  `user_n` char(32) NOT NULL,
  `user_p` char(64) NOT NULL,
  `salt` char(8) NOT NULL,
  `first_name` char(32) NOT NULL,
  `last_name` char(32) NOT NULL,
  `email` text NOT NULL,
  `phone` char(32) DEFAULT NULL,
  `city` char(32) DEFAULT NULL,
  `state` char(32) DEFAULT NULL,
  `zipcode` mediumint(6) DEFAULT NULL,
  `avatar` text,
  `role` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_n` (`user_n`),
  KEY `teamID` (`teamID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `teamID`, `user_n`, `user_p`, `salt`, `first_name`, `last_name`, `email`, `phone`, `city`, `state`, `zipcode`, `avatar`, `role`)
VALUES
	(11,NULL,'student','4234e2d48d58e8595086e4ebc6a238cc67c107779381a23ee8f2485476d95122','264c8c38','Slicky','Coder','things@fullsail.edu',NULL,'Orlando','FL',32792,NULL,NULL),
	(5,NULL,'codeinfused','01756509456b8ed2112b0c034c315b458d9fc4baae65c4e636eba1cb4a5f688b','11054932','Michael','Smotherman','msmotherman@fullsail.com','555-555-5555',NULL,NULL,NULL,NULL,NULL),
	(22,NULL,'aerosakui@yahoo.com','de8f92d425cce0e91f79e97690cb18d5','e0b8c47f','Chris','Whitman','aerosakui@yahoo.com','850-797-1897','Winter Park','Florida',32792,'Things',NULL),
	(45,NULL,'asdf@asdf.com','686e7fbd5b82279f423539f1ae10120def306a257b2dcc128d94fb5af0396c1b','58fc25ce','','','asdf@asdf.com','','','',0,'',NULL),
	(46,NULL,'fullsailgrad@gmail.com','e498f13dcc477d55b5ddfe62ac9ea1df86355ea158dd2410292d4f0870efd74f','a005dc5e','','','fullsailgrad@gmail.com','','','',0,'',NULL),
	(47,NULL,'fullsailgraduate@gmail.com','48c9e2952029f5f375761fec9debbb649d11288d7209b4a2171331957804bb8e','367a0f0a','','','fullsailgraduate@gmail.com','','','',0,'',NULL),
	(48,NULL,'student@fullsail.edu','4074beab516d3e34c705db3ec84f44630bce35cfc88bb105fc5276e82b9239fd','c5586933','Chris','Whitman','student@fullsail.edu','','','',0,'2013 Full Sail University Graduate.',NULL),
	(49,NULL,'thanks@fullsail.edu','6d3fbc01b3151e9ad2a226b6a9318ff2547e72ef4ac0323f5ab4aa60ab7ce70c','b4d59d70','','','thanks@fullsail.edu','','','',0,'',NULL);

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table userslink
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userslink`;

CREATE TABLE `userslink` (
  `userID` int(11) NOT NULL,
  `projectID` int(11) NOT NULL,
  KEY `userID` (`userID`),
  KEY `projectID` (`projectID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `userslink` WRITE;
/*!40000 ALTER TABLE `userslink` DISABLE KEYS */;

INSERT INTO `userslink` (`userID`, `projectID`)
VALUES
	(11,1),
	(11,2),
	(5,1),
	(11,3),
	(11,28),
	(11,29),
	(11,30),
	(11,31),
	(11,32),
	(11,33),
	(11,34),
	(22,35);

/*!40000 ALTER TABLE `userslink` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
