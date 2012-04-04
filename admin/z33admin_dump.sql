-- phpMyAdmin SQL Dump
-- version 3.3.9.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 04, 2012 at 04:42 PM
-- Server version: 5.5.9
-- PHP Version: 5.3.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `z33admin`
--

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_edit` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `marker_id` int(11) NOT NULL,
  `contentType` varchar(63) NOT NULL,
  `url` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `author` varchar(255) NOT NULL,
  `publish` varchar(255) NOT NULL,
  `category` varchar(63) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marker_id` (`marker_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=235 ;

--
-- Dumping data for table `content`
--

INSERT INTO `content` VALUES(55, '2012-04-03 11:39:48', 2, 'Youtube', 'http://www.youtube.com/watch?v=y2msP67D5gY', 'concept Tentvillage Revisited', 'Dré Wapenaar over het concept achter zijn tentsculpturen', 'Dré Wapenaar', 'audiovisuele studio - provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(56, '2012-04-03 11:40:55', 2, 'Youtube', 'http://www.youtube.com/watch?v=f23W8ICn8z0', 'constructie Tentvillage Revisited', 'Dré Wapenaar over de constructiewijze', 'Dré Wapenaar', 'audiovisuele studio - provincie Limburg', 'Constructie');
INSERT INTO `content` VALUES(57, '2012-04-03 11:42:03', 2, 'Youtube', 'http://www.youtube.com/watch?v=zZgj-V_an-w', 'resultaat Tentvillage revisited', 'Dré Wapenaar over wat hij wilt bereiken met zijn tentsculpturen', 'Dré Wapenaar', 'audiovisuele studio - Provincie Limburg', 'Resultaat');
INSERT INTO `content` VALUES(60, '2012-04-03 11:42:59', 2, 'Image', 'http://epics.edm.uhasselt.be/z33/images/birds-perspective rendering5331.jpg', 'Tentvillage Revisited test', 'rendering in vogelperspectief test', 'Dré Wapenaar', 'Dré Wapenaar', 'Concept');
INSERT INTO `content` VALUES(61, '2012-04-04 16:41:59', 12, 'Youtube', 'http://www.youtube.com/watch?v=ZbFPLSTiiCg', 'constructie Twijfelgrens', 'Fred Eerdekens over de uitvoering van Twijfelgrens', 'Fred Eerdekens', 'audiovisuele studio - Provincie Limburg', 'Constructie');
INSERT INTO `content` VALUES(62, '2012-04-04 16:41:59', 12, 'Youtube', 'http://www.youtube.com/watch?v=JXIcyQKiRxc', 'concept Twijfelgrens', 'Fred Eerdekens over het concept achter Twijfelgrens', 'Fred Eerdekens', 'audiovisuele studio - Provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(63, '2012-04-04 16:41:59', 12, 'Youtube', 'http://www.youtube.com/watch?v=VCMx2vBvwCo', 'resultaat Twijfelgrens', 'Fred Eerdekens over het beoogde effect van Twijfelgrens', 'Fred Eerdekens', 'audiovisuele studio - Provincie Limburg', 'Resultaat');
INSERT INTO `content` VALUES(112, '2012-04-03 11:43:50', 2, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tentvillage openingsmoment.jpg', 'Tentvillage Revisited', 'Tentvillage Revisited tijden openingsmoment', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(113, '2012-04-03 11:45:14', 2, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tentvillage stroopfabriek.jpg', 'Tentvillage Revisited', 'Tentvillage Revisited aan de stroopfabriek in Borgloon', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(115, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/twijfelgrens.jpg', 'Twijfelgrens', '', 'Fred Eerdekens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(116, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/twijfelgrens2.jpg', 'Twijfelgrens', '', 'Fred Eerdekens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(117, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/twijfelgrens3.jpg', 'Twijfelgrens', '', 'Fred Eerdekens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(118, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/twijfelgrens4.jpg', 'Twijfelgrens', '', 'Fred Eerdekens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(119, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/twijfelgrens5.jpg', 'Twijfelgrens', '', 'Fred Eerdekens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(122, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tranendreef ver.jpg', 'Tranendreef', 'De tranendreef in de dreef naar het kasteel van Hex', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(123, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tranendreef.jpg', 'Tranendreef', 'De tranendreef in de dreef naar het kasteel van Hex', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(124, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tranendreef2.jpg', 'Tranendreef', 'De tranendreef in de dreef naar het kasteel van Hex', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(125, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/boomtent.jpg', 'Tranendreef', 'Een boomtent in de Tranendreef', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(126, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/boomtent close.jpg', 'Tranendreef', 'Een boomtent in de Tranendreef', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(128, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/boomtent binnen2.jpg', 'Tranendreef', 'Binnenkant van een boomtent in de Tranendreef', 'Dré Wapenaar', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(129, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/TREETENTsketch17788.jpg', 'Boomtent schets', '', 'Dré Wapenaar', 'Dré Wapenaar', 'Concept');
INSERT INTO `content` VALUES(130, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/TREETENTsketch27362.jpg', 'Boomtent schets', '', 'Dré Wapenaar', 'Dré Wapenaar', 'Concept');
INSERT INTO `content` VALUES(131, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/TTsketch18301.jpg', 'Boomtent schets', '', 'Dré Wapenaar', 'Dré Wapenaar', 'Concept');
INSERT INTO `content` VALUES(132, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/TTsteelframe4935.jpg', 'Boomtent stalen frame', '', 'Dré Wapenaar', 'Dré Wapenaar', 'Constructie');
INSERT INTO `content` VALUES(139, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/FRED EERDEKENS-1- tekening.jpg', 'Twijfelgrens', 'tekening', 'Fred Eerdekens', 'Fred Eerdekens', 'Concept');
INSERT INTO `content` VALUES(140, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/FRED EERDEKENS-1- tekening.jpg', 'Twijfelgrens', 'tekening', 'Fred Eerdekens', 'Fred Eerdekens', 'Concept');
INSERT INTO `content` VALUES(141, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/FRED EERDEKENS-1- tekening.jpg', 'Twijfelgrens', 'tekening', 'Fred Eerdekens', 'Fred Eerdekens', 'Concept');
INSERT INTO `content` VALUES(142, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens 3 - foto Johan Jozef Wetzels.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(143, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 2 - foto Johan Jozef Wetzels.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(144, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 2 - foto Johan Jozef Wetzels.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(145, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 2 - foto Johan Jozef Wetzels.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(146, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 2 - foto Johan Jozef Wetzels.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(147, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 2 - foto Johan Jozef Wetzels-1.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(148, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens 3 - foto Johan Jozef Wetzels-1.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Constructie');
INSERT INTO `content` VALUES(149, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 5 - foto Johan Jozef Wetzels-1.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Concept');
INSERT INTO `content` VALUES(150, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 4 - foto Johan Jozef Wetzels-1.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Concept');
INSERT INTO `content` VALUES(151, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens 3 - foto Johan Jozef Wetzels-1.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Concept');
INSERT INTO `content` VALUES(152, '2012-04-04 16:41:59', 12, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Fred Eerdekens - twijfelgrens maquette 5 - foto Johan Jozef Wetzels-1.jpg', 'Twijfelgrens', 'Maquette in kunstencentrum BELGIE', 'Fred Eerdekens', 'Johan Jozef Wetzels', 'Concept');
INSERT INTO `content` VALUES(167, '2012-04-04 16:41:59', 17, 'Image', 'http://epics.edm.uhasselt.be/z33/images/drawing 02 (mail).jpg', 'Memento', 'ontwerptekening', 'Wesley Meuris', 'Wesley Meuris', 'Concept');
INSERT INTO `content` VALUES(168, '2012-04-04 16:41:59', 17, 'Image', 'http://epics.edm.uhasselt.be/z33/images/drawing 03 (mail).jpg', 'Memento', 'ontwerptekening', 'Wesley Meuris', 'Wesley Meuris', 'Concept');
INSERT INTO `content` VALUES(169, '2012-04-04 16:41:59', 17, 'Image', 'http://epics.edm.uhasselt.be/z33/images/drawing 04 (mail).jpg', 'Memento', 'ontwerptekening', 'Wesley Meuris', 'Wesley Meuris', 'Concept');
INSERT INTO `content` VALUES(170, '2012-04-04 16:41:59', 17, 'Image', 'http://epics.edm.uhasselt.be/z33/images/WM locatie foto.jpg', 'Memento', 'locatie foto', 'Wesley Meuris', 'Wesley Meuris', 'Concept');
INSERT INTO `content` VALUES(171, '2012-04-04 16:41:59', 17, 'Image', 'http://epics.edm.uhasselt.be/z33/images/WM locatie fotomontage.jpg', 'Memento', 'locatie foto + ontwerp', 'Wesley Meuris', 'Wesley Meuris', 'Concept');
INSERT INTO `content` VALUES(172, '2012-04-04 16:41:59', 17, 'Image', 'http://epics.edm.uhasselt.be/z33/images/WM plaatsing.jpg', 'Memento', 'locatie op plan', 'Wesley Meuris', 'Wesley Meuris', 'Concept');
INSERT INTO `content` VALUES(174, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/doc8-Kawamata-schwerdtle-1.jpg', 'Destroyed Churhc - Documenta VIII, Kassel - 1987', 'Tadashi Kawamata maakte voor zijn deelname aan Documenta VIII in Kassel een grote houten sculptuur rond de ruïne van een kerk. De kerk werd verwoest tijdens de tweede wereldoorlog maar werd niet zoals de rest van de stad heropgebouwd. De tijd die kan afgelezen worden aan het verval of de bloei van een gebouw is één van de kernelementen uit Kawamata?s werk.', 'Tadashi Kawamata', 'Kristof Vrancken', 'Concept');
INSERT INTO `content` VALUES(175, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/kaw_Biennalewenecja1982.jpg', 'project Biennal Venetië', '1992', 'Tadashi Kawamata', 'Kristof Vrancken', 'Concept');
INSERT INTO `content` VALUES(178, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tadashi-kawamata-013.jpg', 'Gandamaison, Versailles, 2004', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Concept');
INSERT INTO `content` VALUES(181, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/6172839745_9f8ce2cfa0_b.jpg', 'ontwerptekeningen', 'één van de ontwerptekeningen gemaakt tijdens de workshop', 'Tadashi Kawamata', 'Kristof Vrancken', 'Concept');
INSERT INTO `content` VALUES(182, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/6173354694_92b58902ca_b.jpg', 'infosessie', 'tussentijdse infosessie', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(183, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/6173210718_8310d48286_b.jpg', 'bouwen aan project Burchtheuvel', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(184, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/6173249952_c1b4f17d55_b.jpg', 'bouwen aan project Burchtheuvel', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(185, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Tadashi Kawamata_Z33_KV9114.jpg', 'bouwen aan project Burchtheuvel', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(186, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Tadashi Kawamata_Z33_KV9114.jpg', 'bouwen aan project Burchtheuvel', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(187, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/6173304402_292fdc755c_b.jpg', 'bouwen aan project Burchtheuvel', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(188, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/6172698915_65c30a795b_b.jpg', 'bouwen aan project Burchtheuvel', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(189, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Tadashi Kawamata_Z33_KV9194.jpg', 'de ploeg van project Burchtheuvel', 'Studenten en docenten MAD Faculty / Provinciale Hogeschool Limburg: Channah Mourmans, Federica Cecchi, Stephanie Claes, Tatjana Philtjens, Katerin Theys, Karolien De Ryckere, Robbert Errico, Thomas Merckx, Michael Winters, Jeroen Jeuris, Soren Justens, Arnold Winterberg, John Bijnens, Carlien Vanderstukken, Twan Kerckhofs, Vera Thaens, Rianne Kerens, Lien Swerts, Sakeb Haque, Frederic Geurts, Jos Delbroek<br /><br /> <br /><br />Maarten Ruelens, projectverantwoordelijke Z33 / Z-OUT<br /><br />Sofie Hendrikx, projectverantwoordelijke Z33 / Z-OUT <br /><br />Marc Wetzels, productie Z33 / Z-OUT<br /><br /> <br /><br />Tadashi Kawamata', 'Tadashi Kawamata', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(190, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Tadashi Kawamata_Z33_KV9174 (1).jpg', 'Tadashi Kawamata', 'Studenten en docenten MAD Faculty / Provinciale Hogeschool Limburg: Channah Mourmans, Federica Cecchi, Stephanie Claes, Tatjana Philtjens, Katerin Theys, Karolien De Ryckere, Robbert Errico, Thomas Merckx, Michael Winters, Jeroen Jeuris, Soren Justens, Arnold Winterberg, John Bijnens, Carlien Vanderstukken, Twan Kerckhofs, Vera Thaens, Rianne Kerens, Lien Swerts, Sakeb Haque, Frederic Geurts, Jos Delbroek<br /><br /> <br /><br />Maarten Ruelens, projectverantwoordelijke Z33 / Z-OUT<br /><br />Sofie Hendrikx, projectverantwoordelijke Z33 / Z-OUT <br /><br />Marc Wetzels, productie Z33 / Z-OUT<br /><br /> <br /><br />Tadashi Kawamata', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(191, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Tadashi Kawamata_Z33_KV9182.jpg', 'constructie op de burchheuvel', 'Studenten en docenten MAD Faculty / Provinciale Hogeschool Limburg: Channah Mourmans, Federica Cecchi, Stephanie Claes, Tatjana Philtjens, Katerin Theys, Karolien De Ryckere, Robbert Errico, Thomas Merckx, Michael Winters, Jeroen Jeuris, Soren Justens, Arnold Winterberg, John Bijnens, Carlien Vanderstukken, Twan Kerckhofs, Vera Thaens, Rianne Kerens, Lien Swerts, Sakeb Haque, Frederic Geurts, Jos Delbroek<br /><br /> <br /><br />Maarten Ruelens, projectverantwoordelijke Z33 / Z-OUT<br /><br />Sofie Hendrikx, projectverantwoordelijke Z33 / Z-OUT <br /><br />Marc Wetzels, productie Z33 / Z-OUT<br /><br /> <br /><br />Tadashi Kawamata', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(192, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Z33_TadashiKawamata_VK_131_0196.jpg', 'Resultaat', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(193, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Z33_TadashiKawamata_VK_136_0302.jpg', 'Resultaat', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(194, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Z33_TadashiKawamata_VK_136_0302.jpg', 'Resultaat', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(195, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Z33_TadashiKawamata_VK_158_0481.jpg', 'Resultaat', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(196, '2012-04-04 16:41:59', 9, 'Image', 'http://epics.edm.uhasselt.be/z33/images/Z33_TadashiKawamata_VK_183_0602.jpg', 'Resultaat', '', 'Tadashi Kawamata', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(198, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tranendreef - constructie.jpg', 'Boomtent stalen frame', '', 'Dré Wapenaar', 'Dré Wapenaar', 'Constructie');
INSERT INTO `content` VALUES(201, '2012-04-04 16:41:59', 19, 'Image', 'http://epics.edm.uhasselt.be/z33/images/tranendreef - constructie 2.jpg', 'Boomtent stalen frame', '', 'Dré Wapenaar', 'Dré Wapenaar', 'Constructie');
INSERT INTO `content` VALUES(203, '2012-04-04 16:41:59', 9, 'Youtube', 'http://www.youtube.com/watch?v=begVXfLFq8Y', 'Tadashi Kawamta over het concept achter project burchtheuvel', '', 'Tadashi Kawamata', 'AVS  - provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(204, '2012-04-04 16:41:59', 9, 'Youtube', 'http://www.youtube.com/watch?v=3MfMYufm_MM', 'Tadashi Kawamta over het werkproces', '', 'Tadashi Kawamata', 'AVS  - provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(205, '2012-04-04 16:41:59', 9, 'Youtube', 'http://www.youtube.com/watch?v=9PDzjj3e_Zo', 'Tadashi Kawamta over het Resultaat', '', 'Tadashi Kawamata', 'AVS  - provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(206, '2012-04-04 16:41:59', 20, 'Youtube', 'http://www.youtube.com/watch?v=gnNxNFtLsyw', 'Reading between the Lines - constructie', 'Arnout Van Vaerenbergh en Pieterjan Gijs over de technische aspecten van het werk.', 'Gijs Van Vaerenbergh', 'AVS - provincie Limburg', 'Constructie');
INSERT INTO `content` VALUES(207, '2012-04-04 16:41:59', 20, 'Youtube', 'http://www.youtube.com/watch?v=ZnEUSkI9DXo', 'Reading between the Lines - Resultaat', '', 'Gijs Van Vaerenbergh', 'AVS - provincie Limburg', 'Resultaat');
INSERT INTO `content` VALUES(208, '2012-04-04 16:41:59', 20, 'Youtube', 'http://www.youtube.com/watch?v=VYSU-Vae_k4', 'Reading between the Lines - concept', '', 'Gijs Van Vaerenbergh', 'AVS - provincie Limburg', 'Resultaat');
INSERT INTO `content` VALUES(209, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL - atelier.jpg', 'opbouw in atelier', '', 'Gijs Van Vaerenbergh', 'Gijs Van Vaerenbergh', 'Resultaat');
INSERT INTO `content` VALUES(210, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL - transport.jpg', 'transport', '', 'Gijs Van Vaerenbergh', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(211, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL - constructie.jpg', 'Constructie', '', 'Gijs Van Vaerenbergh', 'Kristof Vrancken', 'Constructie');
INSERT INTO `content` VALUES(213, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL.jpg', 'Reading between the Lines', '', 'Gijs Van Vaerenbergh', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(214, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL2.jpg', 'Reading between the Lines', '', 'Gijs Van Vaerenbergh', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(215, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL3.jpg', 'Reading between the Lines', '', 'Gijs Van Vaerenbergh', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(219, '2012-04-04 16:41:59', 20, 'Image', 'http://epics.edm.uhasselt.be/z33/images/RBTL - constructie 2.jpg', 'constructie toren', '', 'Gijs Van Vaerenbergh', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(222, '2012-04-04 16:41:59', 19, 'Youtube', 'http://www.youtube.com/watch?v=VMoacQjvPZw&feature=plcp&context=C4c27773VDvjVQa1PpcFMufTTXYL6mBN3mOuu4UH1x0Y6x39YT120=', 'constructie Tranendreef', 'Time-lapse video over de constructie van het kunstwerk Tranendreef van kunstenaar Fred Eerdekens in 2012 (1/2)', 'Dré Wapenaar', 'audiovisuele studio - Provincie Limburg', 'Constructie');
INSERT INTO `content` VALUES(223, '2012-04-04 16:41:59', 19, 'Youtube', 'http://www.youtube.com/watch?v=c6scXAiZ3c8&feature=context&context=C4c27773VDvjVQa1PpcFMufTTXYL6mBN3mOuu4UH1x0Y6x39YT120=', 'constructie Tranendreef', 'Time-lapse video over de constructie van het kunstwerk Tranendreef van kunstenaar Fred Eerdekens in 2012 (2/2)', 'Dré Wapenaar', 'audiovisuele studio - Provincie Limburg', 'Constructie');
INSERT INTO `content` VALUES(224, '2012-04-04 16:41:59', 27, 'Youtube', 'http://www.youtube.com/watch?v=8AN_UaWp96E', '"concept Field Furniture ""Pure Nature"""', '"Ardie Van Bommel over het concept van Field Furniture ""Pure Nature"""', 'Ardie Van Bommel', 'audiovisuele studio - Provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(225, '2012-04-04 16:41:59', 27, 'Youtube', 'http://www.youtube.com/watch?v=FpBC8yleds4', '"constructie Field Furniture ""Pure Nature"""', '"Ardie Van Bommel over de constructie van constructie Field Furniture ""Pure Nature"""', 'Ardie Van Bommel', 'audiovisuele studio - Provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(226, '2012-04-04 16:41:59', 27, 'Youtube', 'http://www.youtube.com/watch?v=SWIKFy7IAGo', '"resultaat Field Furniture ""Pure Nature"""', '"Ardie Van Bommel over het resultaat van Field Furniture ""Pure Nature"""', 'Ardie Van Bommel', 'audiovisuele studio - Provincie Limburg', 'Concept');
INSERT INTO `content` VALUES(227, '2012-04-04 16:41:59', 25, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pit-pauldevens-proximityeffect07.jpg', 'Proximity Effect', 'resultaat Proximity Effect', 'Paul Devens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(228, '2012-04-04 16:41:59', 27, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pit-ardievanbommel-purenature11.jpg', '"Field Furniture ""Pure Nature"""', '"resultaat Field Furniture ""Pure Nature"" in de Tranendreef"', 'Ardie Van Bommel', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(229, '2012-04-04 16:41:59', 27, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pit-ardievanbommel-purenature13-waseenheid.jpg', '"Field Furniture ""Pure Nature"""', '"resultaat Field Furniture ""Pure Nature"" - Was eenheid"', 'Ardie Van Bommel', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(230, '2012-04-04 16:41:59', 25, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pauldevensconcept.jpg', 'Proximity Effect', 'concept in 3D Proximity Effect', 'Paul Devens', 'Kristof Vrancken', 'Concept');
INSERT INTO `content` VALUES(231, '2012-04-04 16:41:59', 25, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pauldevensresultaat.jpg', 'Proximity Effect', 'resultaat Proximity Effect', 'Paul Devens', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(232, '2012-04-04 16:41:59', 27, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pit-ardievanbommel-purenature00.jpg', '"Field Furniture ""Pure Nature"""', '"resultaat Field Furniture ""Pure Nature"""', 'Ardie Van Bommel', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(233, '2012-04-04 16:41:59', 27, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pit-ardievanbommel-purenature15-toilet.jpg', '"Field Furniture ""Pure Nature"""', '"resultaat Field Furniture ""Pure Nature"" - Toilet"', 'Ardie Van Bommel', 'Kristof Vrancken', 'Resultaat');
INSERT INTO `content` VALUES(234, '2012-04-04 16:41:59', 25, 'Image', 'http://epics.edm.uhasselt.be/z33/images/pit-pauldevens-proximityeffect06.jpg', 'Proximity Effect', 'resultaat Proximity Effect', 'Paul Devens', 'Kristof Vrancken', 'Resultaat');

-- --------------------------------------------------------

--
-- Table structure for table `markers`
--

CREATE TABLE `markers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_edit` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `longitude` varchar(63) COLLATE utf8_unicode_ci NOT NULL,
  `latitude` varchar(63) COLLATE utf8_unicode_ci NOT NULL,
  `markerIcon` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=29 ;

--
-- Dumping data for table `markers`
--

INSERT INTO `markers` VALUES(2, '2012-04-02 10:45:10', 'Dré Wapenaar', 'Tentvillage - Revisited', 'Dré Wapenaar (1961) is vooral bekend om zijn tentsculpturen. Wapenaars creaties van tentdoek bevinden zich op het grensgebied van architectuur, design en beeldhouwkunst. Zijn sculpturen zijn méér dan kijkobjecten. Je kan ze ook echt gebruiken als uitkijkpost of als hotelkamer.', '5.345622982857345', '50.81488171956847', 'http://epics.edm.uhasselt.be/z33/images/Tentenkamp.swf');
INSERT INTO `markers` VALUES(9, '2012-04-02 10:46:10', 'Tadashi Kawamata', 'Project Burchtheuvel', 'Tadashi Kawamata (1953) is bekend om zijn interventies in de open ruimte, gebruik makend van eenvoudige materialen. Voor Kawamata zijn het proces van het het bouwen en de participatie van lokale mensen een belangrijk onderdeel van zijn praktijk.', '5.343820662139196', '50.802543896976545', 'http://localhost:8888/z33admin/uploads/IMG_20120404_151154.jpg');
INSERT INTO `markers` VALUES(12, '2012-04-02 15:32:12', 'Fred Eerdekens', 'Twijfelgrens', 'Fred Eerdekens (1951) heeft een omvangrijk oeuvre van tekstsculpturen die leesbaar worden vanuit een bepaald oogpunt of lichtinval. Hij deconstrueert schrift en voegt betekenislagen toe in een poëtisch beeld waarbij schrift en beeld niet steeds samenvallen.', '5.35495988603476', '50.789427366602354', 'http://epics.edm.uhasselt.be/z33/images/Eerdekens.swf');
INSERT INTO `markers` VALUES(17, '2012-04-02 15:32:52', 'Wesley Meuris', 'Memento', 'Wesley Meuris (1977) stelt in zijn werk onze houding tegenover architecturale archetypes in vraag. Hij construeert bekende vormen zoals bijvoorbeeld een dierenverblijf, maar vult die ruimtes niet verder in. Een installatie van Wesley Meuris bezoeken is een vaak ongrijpbare ervaring.', '5.330022464640574', '50.79621712599798', 'http://epics.edm.uhasselt.be/z33/images/Meuris.swf');
INSERT INTO `markers` VALUES(19, '2012-04-02 15:33:34', 'Dré Wapenaar', 'Tranendreef', 'Dré Wapenaar (1961) is vooral bekend om zijn tentsculpturen.  Wapenaars creaties van tentdoek bevinden zich op het grensgebied van architectuur, design en beeldhouwkunst. Zijn sculpturen zijn méér dan kijkobjecten. Je kan ze ook echt gebruiken als uitkijkpost of als hotelkamer.', '5.38029670715332', '50.78474896292773', 'http://epics.edm.uhasselt.be/z33/images/Boomtenten.swf');
INSERT INTO `markers` VALUES(20, '2012-04-02 15:34:19', 'Gijs Van Vaerenbergh', 'Reading Between The Lines', 'Pieterjan Gijs (1983) en Arnout Van Vaerenbergh (1983) studeerden beide architectuur en werken samen onder de naam Gijs Van Vaerenbergh in een multidisciplinaire praktijk met een sterke focus op de openbare ruimte.', '5.356800856294837', '50.793815335235216', 'http://epics.edm.uhasselt.be/z33/images/Baerenbergh.swf');
INSERT INTO `markers` VALUES(25, '2012-04-02 15:34:59', 'Paul Devens', 'Proximity Effect', 'Paul Devens (1965) stelt over het algemeen de schijnbaar genaturaliseerde concepties van de werkelijkheid in vraag. In zijn werken - van soundscapes over installaties tot performances - is het gevoel van onzekerheid en verrassing die bepaalde situatie aangeven steevast een centraal element.', '5.3647624254226445', '50.793511295300796', 'http://epics.edm.uhasselt.be/z33/images/Devens.swf');
INSERT INTO `markers` VALUES(27, '2012-04-02 15:36:01', 'Ardie Van Bommel', 'Field Furniture "Pure Nature"', 'Bij de boomtenten van Dré Wapenaar in de Tranendreef vind je nu ook Field Furniture "Pure Nature" van Ardie Van Bommel (NL). Zij brengt een zit-, was-, toilet-, en barbecue-eenheid gebaseerd op de paloxen of fruitkisten die je zo vaak ziet in het Haspengouwse landschap. Belangrijk voor Ardie Van Bommel is dat de bezoekers van de Tranendreef elkaar rond haar kunstwerken kunnen ontmoeten.', '5.381416797637963', '50.77812542457376', 'http://epics.edm.uhasselt.be/z33/images/Van_Bommel.swf');
INSERT INTO `markers` VALUES(28, '2012-04-02 15:36:47', 'Aeneas Wilder', 'Untitled #158', 'Aeneas Wilder (UK) bouwt een architecturale structuur in het landschap vlakbij het Klooster van Colen in Kerniel. De ronde kamer met een prachtig uitzicht van 360° wordt afgelijnd door uniforme verticale houten latjes. Rondwandelen in het kunstwerk is een speciale ervaring. Volgens Aeneas Wilder functioneert zijn werk als een lens waardoor de bezoeker zijn gedachten en emoties kan focussen met het landschap van Kerniel als achtergrond.', '5.3594419956207595', '50.814177217838605', 'http://epics.edm.uhasselt.be/z33/images/Wilder.swf');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `content`
--
ALTER TABLE `content`
  ADD CONSTRAINT `content_ibfk_1` FOREIGN KEY (`marker_id`) REFERENCES `markers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
