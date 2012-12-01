-- phpMyAdmin SQL Dump
-- version 3.2.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 13, 2011 at 04:20 PM
-- Server version: 5.1.44
-- PHP Version: 5.3.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dossier_db`
--
CREATE DATABASE `dossier_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `dossier_db`;

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` VALUES(1, 'Full Sail University', 5, '407-679-0100', '3300 University Blvd', 'Orlando', 'FL', 32828, 'www.fullsail.edu', NULL);
INSERT INTO `clients` VALUES(2, 'FakeCo', 5, '555-555-5555', '1234 Nowhere Ave.', 'Busytown', 'NY', 13126, 'www.fakeco.com', NULL);
INSERT INTO `clients` VALUES(3, 'CodeInfused', 5, '555-263-3387', NULL, NULL, NULL, 32792, 'www.codeinfused.com', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` VALUES(1, 1, NULL, 'Task Management App', 'Create a project manager as a rich web application, utilizing jQuery and server-side restful actions accessed via ajax.  Features incorporated should be UX-centric, following the functional specifications provided by the SFW2 contact.', NULL, NULL, 'active', NULL, 11);
INSERT INTO `projects` VALUES(2, 1, NULL, 'WFP Final Project', 'A project concept to be defined and executed with flawless precision and professionalism by the student with the help of Full Sail University''s outstanding educational team.', NULL, NULL, 'active', NULL, 11);
INSERT INTO `projects` VALUES(3, 3, NULL, 'Learning JavaScript', 'Become a ninja with JavaScript.', NULL, NULL, 'delayed', NULL, 5);
INSERT INTO `projects` VALUES(4, 2, NULL, 'No Ones Project', 'This job is worked on by very scary testing ghosts who make sure that content is limited correctly.', NULL, NULL, 'delayed', NULL, 5);
INSERT INTO `projects` VALUES(27, NULL, NULL, 'Student Test', 'This is an emergency test of the student project adding system for SFW2.', NULL, NULL, 'active', 'Wed, 27 Jul 2011 00:17:05 GMT', 11);

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` VALUES(1, 1, 11, 5, 'Creative Brief', 'Prepare creative pitch for the client.  Due date is the client meeting and project kickoff.  Creative document needs:  feature specifications, wireframes, design compositions, style guide, project planning chart.', NULL, 'active', 1, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(2, 1, 11, 5, 'Prototype', 'Develop the HTML and CSS prototype foundation of the project.  Goal is to ready all necessary HTML, CSS, and image elements before client side or server side development begins.', NULL, 'active', 2, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(3, 1, 11, 5, 'Development Milestone', 'First major project milestone, as agreed on with client.  Functionality to have done:  user signup, user login and logout, template loading for landing page and application, initial dashboard content for application.', NULL, 'active', 3, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(4, 1, 11, 5, 'Revisions', 'Revisit all functionality specifications originally planned, and determine current project status.  Schedule client meeting for any revision needs or scope changes before final product launch.', NULL, 'active', 4, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(5, 1, 11, 5, 'Launch', 'Deploy application and remove beta access from live tests.  Hand off all assets to client per contract needs and finalize work.', NULL, 'active', 5, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(6, 2, 11, 5, 'Brainstorm Final Project Concept', 'Before WFP begins, the student should come up with a few ideas for a final project that they would like to leave Full Sail with.  The final project is an opportunity to showcase design and development skills to the industry using whatever you are passionate about.  Get started early!', NULL, 'active', 1, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(7, 4, 11, 11, 'Blah', NULL, NULL, 'active', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `tasks` VALUES(9, 1, 11, 11, 'Return Test', NULL, NULL, 'active', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(128) DEFAULT NULL,
  `description` text,
  `website` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` VALUES(1, 'Scripting For Web', 'This team out of the Full Sail University office in Orlando is focused on the development of projects for WDD instructors on the campus.  The team consists of 1 student.', 'http://www.fullsail.com');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` VALUES(11, NULL, 'student', '1bb683a667421569331ec524f095bbc37e8351118b2ae7cb50d17aacf535f487', '264c8c38', 'Slicky', 'Coder', 'student@fullsail.edu', NULL, 'Orlando', 'FL', 32792, NULL, NULL);
INSERT INTO `users` VALUES(5, NULL, 'codeinfused', '01756509456b8ed2112b0c034c315b458d9fc4baae65c4e636eba1cb4a5f688b', '11054932', 'Michael', 'Smotherman', 'msmotherman@fullsail.com', '555-555-5555', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `userslink`
--

CREATE TABLE `userslink` (
  `userID` int(11) NOT NULL,
  `projectID` int(11) NOT NULL,
  KEY `userID` (`userID`),
  KEY `projectID` (`projectID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userslink`
--

INSERT INTO `userslink` VALUES(11, 1);
INSERT INTO `userslink` VALUES(11, 2);
INSERT INTO `userslink` VALUES(5, 1);
INSERT INTO `userslink` VALUES(11, 3);
INSERT INTO `userslink` VALUES(11, 28);
INSERT INTO `userslink` VALUES(11, 29);
INSERT INTO `userslink` VALUES(11, 30);
INSERT INTO `userslink` VALUES(11, 31);
INSERT INTO `userslink` VALUES(11, 32);
INSERT INTO `userslink` VALUES(11, 33);
INSERT INTO `userslink` VALUES(11, 34);
