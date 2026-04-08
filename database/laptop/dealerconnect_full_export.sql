-- MySQL dump 10.13  Distrib 9.6.0, for macos26.2 (arm64)
--
-- Host: localhost    Database: dealerconnect
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS dealerconnect;
USE dealerconnect;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(255) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `entity_id` bigint DEFAULT NULL,
  `entity_name` varchar(255) NOT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `new_value` text,
  `old_value` text,
  `user_id` bigint DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX4kssf2rtjh7spfpyu5k69diks` (`dealer_id`),
  KEY `IDXhyqpeo0t2pf3vsfip79iph3im` (`entity_name`),
  KEY `IDX9e98b2aeicghtwbqblfd0oiw5` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,'DELETE','2026-03-27 22:25:37.539153',1,1,'Vehicle',NULL,NULL,'{\"id\":1,\"vin\":\"VIN0000000010001\",\"engineNumber\":\"ENG0001\",\"chassisNumber\":\"CHA0001\",\"variant\":{\"id\":1,\"model\":{\"id\":1,\"modelCode\":\"CRETA\",\"modelName\":\"Creta\",\"segment\":\"SUV\",\"launchYear\":2020,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"CRT-E\",\"variantName\":\"E 1.5 Petrol MT\",\"engineType\":{\"id\":2,\"name\":\"1.5L MPi Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"Manual\",\"seatingCapacity\":null,\"exShowroomPrice\":1087000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":1,\"name\":\"Polar White\",\"hexCode\":\"#FFFFFF\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2025,\"mfgDate\":\"2025-08-15\",\"arrivalDate\":\"2025-08-25\",\"status\":\"SOLD\",\"invoiceDate\":null,\"dealerCost\":1000000.00,\"createdAt\":\"2025-09-05T10:00:00\",\"updatedAt\":null}',1,'admin@hyundaidms.in'),(2,'UPDATE','2026-03-27 22:25:58.474342',1,1,'Vehicle',NULL,'{\"id\":1,\"vin\":\"VIN0000000010001\",\"engineNumber\":\"ENG0001\",\"chassisNumber\":\"CHA0001\",\"variant\":{\"id\":1,\"model\":null,\"variantCode\":null,\"variantName\":null,\"engineType\":null,\"transmission\":null,\"seatingCapacity\":5,\"exShowroomPrice\":null,\"isActive\":true,\"createdAt\":\"2026-03-27T22:25:58.469803\"},\"color\":{\"id\":1,\"name\":null,\"hexCode\":null},\"location\":{\"id\":1,\"name\":null,\"address\":null,\"dealer\":null},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2025,\"mfgDate\":\"2025-08-15\",\"arrivalDate\":\"2025-08-25\",\"status\":\"DEMO\",\"invoiceDate\":null,\"dealerCost\":1000000,\"createdAt\":\"2025-09-05T10:00:00\",\"updatedAt\":null}','{\"id\":1,\"vin\":\"VIN0000000010001\",\"engineNumber\":\"ENG0001\",\"chassisNumber\":\"CHA0001\",\"variant\":{\"id\":1,\"model\":null,\"variantCode\":null,\"variantName\":null,\"engineType\":null,\"transmission\":null,\"seatingCapacity\":5,\"exShowroomPrice\":null,\"isActive\":true,\"createdAt\":\"2026-03-27T22:25:58.469803\"},\"color\":{\"id\":1,\"name\":null,\"hexCode\":null},\"location\":{\"id\":1,\"name\":null,\"address\":null,\"dealer\":null},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2025,\"mfgDate\":\"2025-08-15\",\"arrivalDate\":\"2025-08-25\",\"status\":\"DEMO\",\"invoiceDate\":null,\"dealerCost\":1000000,\"createdAt\":\"2025-09-05T10:00:00\",\"updatedAt\":null}',1,'admin@hyundaidms.in'),(3,'DELETE','2026-03-27 22:26:03.712493',1,1,'Vehicle',NULL,NULL,'{\"id\":1,\"vin\":\"VIN0000000010001\",\"engineNumber\":\"ENG0001\",\"chassisNumber\":\"CHA0001\",\"variant\":{\"id\":1,\"model\":{\"id\":1,\"modelCode\":\"CRETA\",\"modelName\":\"Creta\",\"segment\":\"SUV\",\"launchYear\":2020,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"CRT-E\",\"variantName\":\"E 1.5 Petrol MT\",\"engineType\":{\"id\":2,\"name\":\"1.5L MPi Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"Manual\",\"seatingCapacity\":null,\"exShowroomPrice\":1087000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":1,\"name\":\"Polar White\",\"hexCode\":\"#FFFFFF\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2025,\"mfgDate\":\"2025-08-15\",\"arrivalDate\":\"2025-08-25\",\"status\":\"DEMO\",\"invoiceDate\":null,\"dealerCost\":1000000.00,\"createdAt\":\"2025-09-05T10:00:00\",\"updatedAt\":\"2026-03-27T22:25:58.48499\"}',1,'admin@hyundaidms.in'),(4,'UPDATE','2026-03-27 22:33:48.711242',1,1,'Vehicle',NULL,'{\"id\":1,\"vin\":\"VIN0000000010001\",\"engineNumber\":\"ENG0001\",\"chassisNumber\":\"CHA0001\",\"variant\":{\"id\":1,\"model\":null,\"variantCode\":null,\"variantName\":null,\"engineType\":null,\"transmission\":null,\"seatingCapacity\":5,\"exShowroomPrice\":null,\"isActive\":true,\"createdAt\":\"2026-03-27T22:33:48.704644\"},\"color\":{\"id\":1,\"name\":null,\"hexCode\":null},\"location\":{\"id\":1,\"name\":null,\"address\":null,\"dealer\":null},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2025,\"mfgDate\":\"2025-08-15\",\"arrivalDate\":\"2025-08-25\",\"status\":\"ALLOCATED\",\"invoiceDate\":null,\"dealerCost\":1000000,\"createdAt\":\"2025-09-05T10:00:00\",\"updatedAt\":\"2026-03-27T22:25:58.48499\"}','{\"id\":1,\"vin\":\"VIN0000000010001\",\"engineNumber\":\"ENG0001\",\"chassisNumber\":\"CHA0001\",\"variant\":{\"id\":1,\"model\":{\"id\":1,\"modelCode\":\"CRETA\",\"modelName\":\"Creta\",\"segment\":\"SUV\",\"launchYear\":2020,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"CRT-E\",\"variantName\":\"E 1.5 Petrol MT\",\"engineType\":{\"id\":2,\"name\":\"1.5L MPi Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"Manual\",\"seatingCapacity\":null,\"exShowroomPrice\":1087000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":1,\"name\":\"Polar White\",\"hexCode\":\"#FFFFFF\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2025,\"mfgDate\":\"2025-08-15\",\"arrivalDate\":\"2025-08-25\",\"status\":\"DEMO\",\"invoiceDate\":null,\"dealerCost\":1000000.00,\"createdAt\":\"2025-09-05T10:00:00\",\"updatedAt\":\"2026-03-27T22:25:58.48499\"}',1,'admin@hyundaidms.in'),(5,'DELETE','2026-03-27 22:33:57.862800',1,106,'Vehicle',NULL,NULL,'{\"id\":106,\"vin\":\"VBKG26A001\",\"engineNumber\":\"EA001\",\"chassisNumber\":\"CA001\",\"variant\":{\"id\":3,\"model\":{\"id\":2,\"modelCode\":\"VENUE\",\"modelName\":\"Venue\",\"segment\":\"Compact SUV\",\"launchYear\":2019,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"VEN-S\",\"variantName\":\"S 1.2 Petrol MT\",\"engineType\":{\"id\":1,\"name\":\"1.2L Kappa Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"Manual\",\"seatingCapacity\":null,\"exShowroomPrice\":894000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":7,\"name\":\"Abyss Black\",\"hexCode\":\"#1A1A1A\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2026,\"mfgDate\":\"2026-03-01\",\"arrivalDate\":\"2026-03-10\",\"status\":\"ALLOCATED\",\"invoiceDate\":null,\"dealerCost\":880000.00,\"createdAt\":null,\"updatedAt\":null}',1,'admin@hyundaidms.in'),(6,'DELETE','2026-03-27 22:34:09.626406',1,106,'Vehicle',NULL,NULL,'{\"id\":106,\"vin\":\"VBKG26A001\",\"engineNumber\":\"EA001\",\"chassisNumber\":\"CA001\",\"variant\":{\"id\":3,\"model\":{\"id\":2,\"modelCode\":\"VENUE\",\"modelName\":\"Venue\",\"segment\":\"Compact SUV\",\"launchYear\":2019,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"VEN-S\",\"variantName\":\"S 1.2 Petrol MT\",\"engineType\":{\"id\":1,\"name\":\"1.2L Kappa Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"Manual\",\"seatingCapacity\":null,\"exShowroomPrice\":894000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":7,\"name\":\"Abyss Black\",\"hexCode\":\"#1A1A1A\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2026,\"mfgDate\":\"2026-03-01\",\"arrivalDate\":\"2026-03-10\",\"status\":\"ALLOCATED\",\"invoiceDate\":null,\"dealerCost\":880000.00,\"createdAt\":null,\"updatedAt\":null}',1,'admin@hyundaidms.in'),(7,'DELETE','2026-03-27 22:36:56.158966',1,106,'Vehicle',NULL,NULL,'{\"id\":106,\"vin\":\"VBKG26A001\",\"engineNumber\":\"EA001\",\"chassisNumber\":\"CA001\",\"variant\":{\"id\":3,\"model\":{\"id\":2,\"modelCode\":\"VENUE\",\"modelName\":\"Venue\",\"segment\":\"Compact SUV\",\"launchYear\":2019,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"VEN-S\",\"variantName\":\"S 1.2 Petrol MT\",\"engineType\":{\"id\":1,\"name\":\"1.2L Kappa Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"Manual\",\"seatingCapacity\":null,\"exShowroomPrice\":894000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":7,\"name\":\"Abyss Black\",\"hexCode\":\"#1A1A1A\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2026,\"mfgDate\":\"2026-03-01\",\"arrivalDate\":\"2026-03-10\",\"status\":\"ALLOCATED\",\"invoiceDate\":null,\"dealerCost\":880000.00,\"createdAt\":null,\"updatedAt\":null}',1,'admin@hyundaidms.in'),(8,'CREATE','2026-03-27 22:44:46.117261',1,52,'Customer',NULL,'{\"id\":52,\"customerCode\":\"CST-DLR01-0048\",\"firstName\":\"Thivi\",\"lastName\":\"Kumar\",\"email\":\"\",\"phone\":\"7907956075\",\"alternatePhone\":\"\",\"dateOfBirth\":null,\"gender\":null,\"panNumber\":\"\",\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":\"\",\"gstNumber\":\"\",\"createdAt\":\"2026-03-27T22:44:46.072816\",\"updatedAt\":\"2026-03-27T22:44:46.072818\",\"addresses\":[{\"id\":3,\"type\":\"HOME\",\"line1\":\"\",\"line2\":null,\"city\":\"\",\"state\":\"\",\"pincode\":\"\",\"isPrimary\":true}]}',NULL,1,'admin@hyundaidms.in'),(9,'DELETE','2026-03-28 10:03:10.028718',1,107,'Vehicle',NULL,NULL,'{\"id\":107,\"vin\":\"VBKG26A002\",\"engineNumber\":\"EA002\",\"chassisNumber\":\"CA002\",\"variant\":{\"id\":6,\"model\":{\"id\":4,\"modelCode\":\"I20\",\"modelName\":\"i20\",\"segment\":\"Premium Hatchback\",\"launchYear\":2020,\"isActive\":null,\"createdAt\":null},\"variantCode\":\"I20-ASTA\",\"variantName\":\"Asta (O) 1.2 Petrol IVT\",\"engineType\":{\"id\":1,\"name\":\"1.2L Kappa Petrol\",\"fuelCategory\":\"Petrol\"},\"transmission\":\"IVT\",\"seatingCapacity\":null,\"exShowroomPrice\":1116000.00,\"isActive\":null,\"createdAt\":null},\"color\":{\"id\":9,\"name\":\"Atlas White\",\"hexCode\":\"#F5F5DC\"},\"location\":{\"id\":1,\"name\":\"Main Showroom\",\"address\":\"Block A, City Center\",\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"}},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"mfgYear\":2026,\"mfgDate\":\"2026-03-01\",\"arrivalDate\":\"2026-03-10\",\"status\":\"ALLOCATED\",\"invoiceDate\":null,\"dealerCost\":770000.00,\"createdAt\":null,\"updatedAt\":null}',3,'rahul.sales@hyundaidms.in'),(10,'CREATE','2026-03-30 21:20:25.474669',1,53,'Customer',NULL,'{\"id\":53,\"customerCode\":\"CST-DLR01-0049\",\"firstName\":\"Girish\",\"lastName\":\"Kum\",\"email\":\"\",\"phone\":\"9446210744\",\"alternatePhone\":\"\",\"dateOfBirth\":null,\"gender\":null,\"panNumber\":\"\",\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":\"\",\"gstNumber\":\"\",\"createdAt\":\"2026-03-30T21:20:25.396\",\"updatedAt\":\"2026-03-30T21:20:25.396002\",\"addresses\":[{\"id\":4,\"type\":\"HOME\",\"line1\":\"\",\"line2\":null,\"city\":\"\",\"state\":\"\",\"pincode\":\"\",\"isPrimary\":true}]}',NULL,1,'admin@hyundaidms.in'),(11,'DELETE','2026-03-30 21:20:33.573627',1,46,'Customer',NULL,NULL,'{\"id\":46,\"customerCode\":\"CUST-L-48977\",\"firstName\":\"Girish\",\"lastName\":\"\",\"email\":null,\"phone\":\"7907956075\",\"alternatePhone\":null,\"dateOfBirth\":null,\"gender\":null,\"panNumber\":null,\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":null,\"gstNumber\":null,\"createdAt\":\"2026-03-25T21:35:48.977489\",\"updatedAt\":\"2026-03-26T21:29:00.699992\",\"addresses\":[]}',1,'admin@hyundaidms.in'),(12,'DELETE','2026-03-30 21:20:37.556909',1,53,'Customer',NULL,NULL,'{\"id\":53,\"customerCode\":\"CST-DLR01-0049\",\"firstName\":\"Girish\",\"lastName\":\"Kum\",\"email\":\"\",\"phone\":\"9446210744\",\"alternatePhone\":\"\",\"dateOfBirth\":null,\"gender\":null,\"panNumber\":\"\",\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":\"\",\"gstNumber\":\"\",\"createdAt\":\"2026-03-30T21:20:25.396\",\"updatedAt\":\"2026-03-30T21:20:25.396002\",\"addresses\":[{\"id\":4,\"type\":\"HOME\",\"line1\":\"\",\"line2\":null,\"city\":\"\",\"state\":\"\",\"pincode\":\"\",\"isPrimary\":true}]}',1,'admin@hyundaidms.in'),(13,'DELETE','2026-03-30 21:20:39.674012',1,49,'Customer',NULL,NULL,'{\"id\":49,\"customerCode\":\"CUST518101\",\"firstName\":\"giri\",\"lastName\":\"kumar\",\"email\":null,\"phone\":\"788\",\"alternatePhone\":null,\"dateOfBirth\":null,\"gender\":null,\"panNumber\":null,\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":null,\"gstNumber\":null,\"createdAt\":\"2026-03-25T22:05:18.10108\",\"updatedAt\":\"2026-03-26T21:29:00.700109\",\"addresses\":[{\"id\":1,\"type\":\"HOME\",\"line1\":\"\",\"line2\":null,\"city\":\"\",\"state\":\"\",\"pincode\":\"\",\"isPrimary\":true}]}',1,'admin@hyundaidms.in'),(14,'CREATE','2026-03-31 07:02:36.426057',1,114,'Lead',NULL,'{\"id\":114,\"leadNumber\":\"LD0051\",\"customer\":{\"id\":54,\"customerCode\":\"CUST-L-56359\",\"firstName\":\"Vijay\",\"lastName\":\"Kumar\",\"email\":null,\"phone\":\"7907956075\",\"alternatePhone\":null,\"dateOfBirth\":null,\"gender\":null,\"panNumber\":null,\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":null,\"gstNumber\":null,\"createdAt\":\"2026-03-31T07:02:36.360226\",\"updatedAt\":\"2026-03-31T07:02:36.360229\",\"addresses\":[]},\"source\":{\"id\":5,\"name\":null},\"assignedTo\":{\"id\":1,\"employeeCode\":null,\"firstName\":null,\"lastName\":null,\"email\":null,\"phone\":null,\"passwordHash\":null,\"department\":null,\"role\":null,\"dealer\":null,\"manager\":null,\"dateOfJoin\":null,\"isActive\":true,\"deactivatedByName\":null,\"deactivatedAt\":null,\"failedLoginAttempts\":0,\"isLocked\":false,\"createdAt\":\"2026-03-31T07:02:36.404084\",\"updatedAt\":\"2026-03-31T07:02:36.404087\"},\"preferredModel\":{\"id\":1,\"modelCode\":null,\"modelName\":null,\"segment\":null,\"launchYear\":null,\"isActive\":null,\"createdAt\":null},\"preferredVariant\":{\"id\":1,\"model\":null,\"variantCode\":null,\"variantName\":null,\"engineType\":null,\"transmission\":null,\"seatingCapacity\":5,\"exShowroomPrice\":null,\"isActive\":true,\"createdAt\":\"2026-03-31T07:02:36.404206\"},\"preferredColor\":{\"id\":2,\"name\":null,\"hexCode\":null},\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"status\":\"NEW\",\"remarks\":\"He is very interested in creta.\",\"expectedCloseDate\":\"2026-04-15\",\"createdAt\":\"2026-03-31T07:02:36.404118\",\"updatedAt\":\"2026-03-31T07:02:36.404119\"}',NULL,1,'admin@hyundaidms.in'),(15,'UPDATE','2026-03-31 07:02:50.648976',1,54,'Customer',NULL,'{\"id\":54,\"customerCode\":\"CUST-L-56359\",\"firstName\":\"Vijay\",\"lastName\":\"Kumar\",\"email\":null,\"phone\":\"7907956075\",\"alternatePhone\":null,\"dateOfBirth\":null,\"gender\":\"MALE\",\"panNumber\":null,\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":null,\"gstNumber\":null,\"createdAt\":\"2026-03-31T07:02:36.360226\",\"updatedAt\":\"2026-03-31T07:02:36.360229\",\"addresses\":[{\"id\":5,\"type\":\"HOME\",\"line1\":\"\",\"line2\":null,\"city\":\"\",\"state\":\"\",\"pincode\":\"\",\"isPrimary\":true}]}','{\"id\":54,\"customerCode\":\"CUST-L-56359\",\"firstName\":\"Vijay\",\"lastName\":\"Kumar\",\"email\":null,\"phone\":\"7907956075\",\"alternatePhone\":null,\"dateOfBirth\":null,\"gender\":null,\"panNumber\":null,\"aadhaarNumber\":null,\"dealer\":{\"id\":1,\"dealerCode\":\"DLR-CHE-001\",\"name\":\"Hyundai Chennai\",\"city\":\"Chennai\",\"state\":\"Tamil Nadu\",\"address\":\"Coimbatore\",\"gstNumber\":null,\"contactName\":\"S Girish Kumar\",\"contactPhone\":\"7907956075\",\"contactEmail\":\"admin@hyundaidms.in\",\"status\":\"ACTIVE\",\"deactivatedByName\":null,\"deactivatedAt\":null,\"createdAt\":\"2026-03-26T20:12:10.551618\",\"updatedAt\":\"2026-03-26T20:12:10.551625\"},\"customerType\":\"INDIVIDUAL\",\"companyName\":null,\"gstNumber\":null,\"createdAt\":\"2026-03-31T07:02:36.360226\",\"updatedAt\":\"2026-03-31T07:02:36.360229\",\"addresses\":[]}',1,'admin@hyundaidms.in');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banks`
--

DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `contact` varchar(20) DEFAULT NULL,
  `ifsc_prefix` varchar(10) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_gfnfs2s5a771weqm28yvb2h5` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banks`
--

LOCK TABLES `banks` WRITE;
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `accessories_amt` decimal(10,2) DEFAULT NULL,
  `booking_number` varchar(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `ex_showroom` decimal(12,2) NOT NULL,
  `expected_delivery` date DEFAULT NULL,
  `insurance_amt` decimal(10,2) DEFAULT NULL,
  `registration_amt` decimal(10,2) DEFAULT NULL,
  `remarks` text,
  `status` enum('BOOKED','ALLOCATED','INVOICED','DELIVERED','CANCELLED') DEFAULT NULL,
  `tcs_amt` decimal(10,2) DEFAULT NULL,
  `total_on_road` decimal(12,2) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `color_id` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `lead_id` bigint DEFAULT NULL,
  `sales_exec_id` bigint NOT NULL,
  `variant_id` bigint NOT NULL,
  `vehicle_id` bigint DEFAULT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_e2b8ksk9hptq6l8msdvoo6anv` (`booking_number`),
  KEY `IDXphrr66uyd2jikuyab1vjc7b1x` (`status`),
  KEY `IDXrkliokwtt5gf3npiaklvb2f8k` (`customer_id`),
  KEY `IDXp9607uwa5thlwbhoocd1yj6v2` (`sales_exec_id`),
  KEY `FK657c82c6ijgmv1bg9r6osc9ea` (`color_id`),
  KEY `FKlpe6gqtt9upuwnhcnmvl8dvsb` (`lead_id`),
  KEY `FK1f9yt3j2r3r9yqhlcvl0k5c7a` (`variant_id`),
  KEY `FKc0062bk3bchs55diw805avxq` (`vehicle_id`),
  KEY `IDX3po1suvrjrbq45jnhw1k6l0uq` (`dealer_id`),
  CONSTRAINT `FK1f9yt3j2r3r9yqhlcvl0k5c7a` FOREIGN KEY (`variant_id`) REFERENCES `vehicle_variants` (`id`),
  CONSTRAINT `FK49un35lp3qourni6a00xmalgb` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`),
  CONSTRAINT `FK657c82c6ijgmv1bg9r6osc9ea` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`),
  CONSTRAINT `FK71vaofrux6j0cv8f6e4jme7eo` FOREIGN KEY (`sales_exec_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `FKbvfibgflhsb0g2hnjauiv5khs` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `FKc0062bk3bchs55diw805avxq` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `FKlpe6gqtt9upuwnhcnmvl8dvsb` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,NULL,'BKG0001','2025-09-20 11:00:00.000000',NULL,1087000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,1250000.00,'2026-03-26 21:29:00.981835',1,1,1,3,1,1,1,NULL,NULL),(2,NULL,'BKG0002','2025-12-10 14:00:00.000000',NULL,1116000.00,NULL,NULL,NULL,NULL,'ALLOCATED',NULL,1285000.00,'2026-03-26 21:29:00.981927',2,4,4,4,6,2,1,NULL,NULL),(3,NULL,'BKG0003','2025-10-25 10:30:00.000000',NULL,2000000.00,NULL,NULL,NULL,NULL,'INVOICED',NULL,2300000.00,'2026-03-26 21:29:00.981977',7,8,8,3,12,6,1,NULL,NULL),(4,NULL,'BKG0004','2025-12-20 15:45:00.000000',NULL,3546000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,4070000.00,'2026-03-26 21:29:00.982035',5,10,10,8,7,7,1,NULL,NULL),(5,NULL,'BKG0005','2026-02-10 11:20:00.000000',NULL,1900000.00,NULL,NULL,NULL,NULL,'BOOKED',NULL,2185000.00,'2026-03-26 21:29:00.982119',8,12,12,4,2,NULL,1,NULL,NULL),(6,NULL,'BKG0006','2025-09-10 11:00:00.000000',NULL,1423000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,1650000.00,'2026-03-26 21:29:00.982165',1,16,16,3,5,11,1,NULL,NULL),(7,NULL,'BKG0007','2025-09-25 14:00:00.000000',NULL,1900000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,2185000.00,'2026-03-26 21:29:00.982201',2,19,19,3,2,12,1,NULL,NULL),(8,NULL,'BKG0008','2025-10-20 10:30:00.000000',NULL,3546000.00,NULL,NULL,NULL,NULL,'INVOICED',NULL,4070000.00,'2026-03-26 21:29:00.982236',7,23,23,4,7,13,1,NULL,NULL),(9,NULL,'BKG0009','2025-10-30 15:45:00.000000',NULL,1087000.00,NULL,NULL,NULL,NULL,'ALLOCATED',NULL,1250000.00,'2026-03-26 21:29:00.982273',5,25,25,3,1,14,1,NULL,NULL),(10,NULL,'BKG0010','2025-11-15 11:20:00.000000',NULL,1900000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,2185000.00,'2026-03-26 21:29:00.982307',8,27,27,8,2,15,1,NULL,NULL),(11,NULL,'BKG0011','2025-12-10 11:00:00.000000',NULL,3546000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,4070000.00,'2026-03-26 21:29:00.982338',1,31,31,3,7,16,1,NULL,NULL),(12,NULL,'BKG0012','2025-12-25 14:00:00.000000',NULL,894000.00,NULL,NULL,NULL,NULL,'ALLOCATED',NULL,1030000.00,'2026-03-26 21:29:00.982378',2,34,34,3,3,17,1,NULL,NULL),(13,NULL,'BKG0013','2026-01-20 10:30:00.000000',NULL,4495000.00,NULL,NULL,NULL,NULL,'INVOICED',NULL,5170000.00,'2026-03-26 21:29:00.982420',7,38,38,4,8,18,1,NULL,NULL),(14,NULL,'BKG0014','2026-01-30 15:45:00.000000',NULL,1423000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,1650000.00,'2026-03-26 21:29:00.982451',5,40,40,3,5,19,1,NULL,NULL),(16,NULL,'BK0016','2026-03-01 10:30:00.000000',NULL,1087000.00,NULL,NULL,NULL,NULL,'BOOKED',NULL,1250000.00,'2026-03-26 21:29:00.982468',1,1,46,3,1,NULL,1,NULL,NULL),(17,NULL,'BK0017','2026-03-05 11:45:00.000000',NULL,894000.00,NULL,NULL,NULL,NULL,'BOOKED',NULL,1050000.00,'2026-03-26 21:29:00.982620',2,2,47,4,3,NULL,1,NULL,NULL),(18,NULL,'BK0018','2026-03-12 09:20:00.000000',NULL,1116000.00,NULL,NULL,NULL,NULL,'BOOKED',NULL,1300000.00,'2026-03-26 21:29:00.982651',4,4,49,3,6,NULL,1,NULL,NULL),(19,NULL,'BKG26-D001',NULL,15000.00,930000.00,'2025-10-20',NULL,NULL,NULL,'DELIVERED',NULL,1030000.00,'2026-03-26 21:29:00.982676',7,1,51,3,3,81,1,NULL,NULL),(20,NULL,'BKG26-D002',NULL,15000.00,820000.00,'2025-10-20',NULL,NULL,NULL,'DELIVERED',NULL,920000.00,'2026-03-26 21:29:00.982716',9,2,52,4,6,82,1,NULL,NULL),(21,NULL,'BKG26-D003',NULL,15000.00,1170000.00,'2025-11-14',NULL,NULL,NULL,'DELIVERED',NULL,1270000.00,'2026-03-26 21:29:00.982769',5,3,53,8,9,83,1,NULL,NULL),(22,NULL,'BKG26-D004',NULL,15000.00,1140000.00,'2025-11-14',NULL,NULL,NULL,'DELIVERED',NULL,1240000.00,'2026-03-26 21:29:00.982803',4,4,54,3,10,84,1,NULL,NULL),(23,NULL,'BKG26-D005',NULL,15000.00,1400000.00,'2025-11-24',NULL,NULL,NULL,'DELIVERED',NULL,1500000.00,'2026-03-26 21:29:00.982844',1,5,55,4,11,85,1,NULL,NULL),(24,NULL,'BKG26-D006',NULL,15000.00,930000.00,'2025-12-15',NULL,NULL,NULL,'DELIVERED',NULL,1030000.00,'2026-03-26 21:29:00.982880',9,6,56,8,3,86,1,NULL,NULL),(25,NULL,'BKG26-D007',NULL,15000.00,820000.00,'2025-12-15',NULL,NULL,NULL,'DELIVERED',NULL,920000.00,'2026-03-26 21:29:00.982915',7,7,57,3,6,87,1,NULL,NULL),(26,NULL,'BKG26-D008',NULL,15000.00,1170000.00,'2025-12-25',NULL,NULL,NULL,'DELIVERED',NULL,1270000.00,'2026-03-26 21:29:00.982937',4,8,58,4,9,88,1,NULL,NULL),(27,NULL,'BKG26-D009',NULL,15000.00,1140000.00,'2026-01-14',NULL,NULL,NULL,'DELIVERED',NULL,1240000.00,'2026-03-26 21:29:00.982968',1,9,59,8,10,89,1,NULL,NULL),(28,NULL,'BKG26-D010',NULL,15000.00,1400000.00,'2026-01-14',NULL,NULL,NULL,'DELIVERED',NULL,1500000.00,'2026-03-26 21:29:00.982989',5,10,60,3,11,90,1,NULL,NULL),(29,NULL,'BKG26-D011',NULL,15000.00,930000.00,'2026-02-04',NULL,NULL,NULL,'DELIVERED',NULL,1030000.00,'2026-03-26 21:29:00.983011',4,1,61,4,3,91,1,NULL,NULL),(30,NULL,'BKG26-D012',NULL,15000.00,820000.00,'2026-02-19',NULL,NULL,NULL,'DELIVERED',NULL,920000.00,'2026-03-26 21:29:00.983031',1,2,62,8,6,92,1,NULL,NULL),(31,NULL,'BKG26-D013',NULL,15000.00,1170000.00,'2026-02-19',NULL,NULL,NULL,'DELIVERED',NULL,1270000.00,'2026-03-26 21:29:00.983052',9,3,63,3,9,93,1,NULL,NULL),(32,NULL,'BKG26-D014',NULL,15000.00,1140000.00,'2026-03-03',NULL,NULL,NULL,'DELIVERED',NULL,1240000.00,'2026-03-26 21:29:00.983072',7,4,64,4,10,94,1,NULL,NULL),(33,NULL,'BKG26-D015',NULL,15000.00,1400000.00,'2026-03-03',NULL,NULL,NULL,'DELIVERED',NULL,1500000.00,'2026-03-26 21:29:00.983091',4,5,65,8,11,95,1,NULL,NULL),(34,NULL,'BKG26-I001',NULL,10000.00,930000.00,'2026-03-07',NULL,NULL,NULL,'INVOICED',NULL,1030000.00,'2026-03-26 21:29:00.983111',5,6,66,3,3,96,1,NULL,NULL),(35,NULL,'BKG26-I002',NULL,10000.00,820000.00,'2026-03-07',NULL,NULL,NULL,'INVOICED',NULL,920000.00,'2026-03-26 21:29:00.983135',7,7,67,4,6,97,1,NULL,NULL),(36,NULL,'BKG26-I003',NULL,10000.00,1170000.00,'2026-03-17',NULL,NULL,NULL,'INVOICED',NULL,1270000.00,'2026-03-26 21:29:00.983154',9,8,68,8,9,98,1,NULL,NULL),(37,NULL,'BKG26-I004',NULL,10000.00,1140000.00,'2026-03-17',NULL,NULL,NULL,'INVOICED',NULL,1240000.00,'2026-03-26 21:29:00.983173',1,9,69,3,10,99,1,NULL,NULL),(38,NULL,'BKG26-I005',NULL,10000.00,1400000.00,'2026-03-22',NULL,NULL,NULL,'INVOICED',NULL,1500000.00,'2026-03-26 21:29:00.983192',4,10,70,4,11,100,1,NULL,NULL),(39,NULL,'BKG26-I006',NULL,10000.00,930000.00,'2026-03-22',NULL,NULL,NULL,'INVOICED',NULL,1030000.00,'2026-03-26 21:29:00.983211',9,1,71,8,3,101,1,NULL,NULL),(40,NULL,'BKG26-I007',NULL,10000.00,820000.00,'2026-03-27',NULL,NULL,NULL,'INVOICED',NULL,920000.00,'2026-03-26 21:29:00.983231',4,2,72,3,6,102,1,NULL,NULL),(41,NULL,'BKG26-I008',NULL,10000.00,1170000.00,'2026-03-27',NULL,NULL,NULL,'INVOICED',NULL,1270000.00,'2026-03-26 21:29:00.983250',1,3,73,4,9,103,1,NULL,NULL),(42,NULL,'BKG26-I009',NULL,10000.00,1140000.00,'2026-03-31',NULL,NULL,NULL,'INVOICED',NULL,1240000.00,'2026-03-26 21:29:00.983269',7,4,74,8,10,104,1,NULL,NULL),(43,NULL,'BKG26-I010',NULL,10000.00,1400000.00,'2026-03-31',NULL,NULL,NULL,'INVOICED',NULL,1500000.00,'2026-03-26 21:29:00.983288',5,5,75,3,11,105,1,NULL,NULL),(49,NULL,'BKG26-A001',NULL,5000.00,930000.00,'2026-04-24',NULL,NULL,NULL,'BOOKED',NULL,1030000.00,'2026-03-26 21:29:00.983307',7,6,76,4,3,NULL,1,NULL,NULL),(50,NULL,'BKG26-A002',NULL,5000.00,820000.00,'2026-04-24',NULL,NULL,NULL,'BOOKED',NULL,920000.00,'2026-03-26 21:29:00.983326',9,7,77,8,6,NULL,1,NULL,NULL),(51,NULL,'BKG26-A003',NULL,5000.00,1170000.00,'2026-04-29',NULL,NULL,NULL,'ALLOCATED',NULL,1270000.00,'2026-03-26 21:29:00.983345',5,8,78,3,9,108,1,NULL,NULL),(52,NULL,'BKG26-A004',NULL,5000.00,1140000.00,'2026-04-29',NULL,NULL,NULL,'ALLOCATED',NULL,1240000.00,'2026-03-26 21:29:00.983364',4,9,79,4,10,109,1,NULL,NULL),(53,NULL,'BKG26-A005',NULL,5000.00,1400000.00,'2026-05-02',NULL,NULL,NULL,'ALLOCATED',NULL,1500000.00,'2026-03-26 21:29:00.983383',1,10,80,8,11,110,1,NULL,NULL),(54,NULL,'BKG26-A006',NULL,5000.00,930000.00,'2026-05-02',NULL,NULL,NULL,'ALLOCATED',NULL,1030000.00,'2026-03-26 21:29:00.983402',9,1,81,3,3,111,1,NULL,NULL),(55,NULL,'BKG26-A007',NULL,5000.00,820000.00,'2026-05-04',NULL,NULL,NULL,'ALLOCATED',NULL,920000.00,'2026-03-26 21:29:00.983422',4,2,82,4,6,112,1,NULL,NULL),(56,NULL,'BKG26-A008',NULL,5000.00,1170000.00,'2026-05-04',NULL,NULL,NULL,'ALLOCATED',NULL,1270000.00,'2026-03-26 21:29:00.983441',7,3,83,8,9,113,1,NULL,NULL),(57,NULL,'BKG26-A009',NULL,5000.00,1140000.00,'2026-05-06',NULL,NULL,NULL,'ALLOCATED',NULL,1240000.00,'2026-03-26 21:29:00.983460',9,4,84,3,10,114,1,NULL,NULL),(58,NULL,'BKG26-A010',NULL,5000.00,1400000.00,'2026-05-06',NULL,NULL,NULL,'ALLOCATED',NULL,1500000.00,'2026-03-26 21:29:00.983480',5,5,85,4,11,115,1,NULL,NULL),(65,0.00,'BKG6603259','2026-03-25 22:06:43.259464',100000.00,738000.00,'2026-06-05',0.00,0.00,NULL,'BOOKED',0.00,738000.00,'2026-03-26 21:29:00.983511',8,46,NULL,3,9,8,1,NULL,NULL),(67,NULL,'BKG-2026-04-001','2026-04-02 10:00:00.000000',NULL,1087000.00,NULL,NULL,NULL,NULL,'BOOKED',NULL,1250000.00,NULL,1,64,119,4,1,NULL,1,NULL,NULL),(68,NULL,'BKG-2026-04-002','2026-04-01 15:30:00.000000',NULL,794000.00,NULL,NULL,NULL,NULL,'INVOICED',NULL,920000.00,NULL,4,60,115,3,3,NULL,1,NULL,NULL),(69,NULL,'BKG-2026-04-003','2026-04-01 16:00:00.000000',NULL,1850000.00,NULL,NULL,NULL,NULL,'DELIVERED',NULL,2150000.00,NULL,5,62,117,8,5,NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colors`
--

DROP TABLE IF EXISTS `colors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hex_code` varchar(10) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_kfulqa7c70otb7t3uwkgcpy43` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colors`
--

LOCK TABLES `colors` WRITE;
/*!40000 ALTER TABLE `colors` DISABLE KEYS */;
INSERT INTO `colors` VALUES (1,'#FFFFFF','Polar White'),(2,'#C0C0C0','Typhoon Silver'),(3,'#808080','Titan Grey'),(4,'#000000','Phantom Black'),(5,'#FF0000','Fiery Red'),(6,'#000080','Starry Night'),(7,'#1A1A1A','Abyss Black'),(8,'#C3B091','Ranger Khaki'),(9,'#F5F5DC','Atlas White');
/*!40000 ALTER TABLE `colors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_addresses`
--

DROP TABLE IF EXISTS `customer_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `city` varchar(100) NOT NULL,
  `is_primary` bit(1) DEFAULT NULL,
  `line1` varchar(255) NOT NULL,
  `line2` varchar(255) DEFAULT NULL,
  `pincode` varchar(10) NOT NULL,
  `state` varchar(100) NOT NULL,
  `type` enum('HOME','OFFICE','OTHER') DEFAULT NULL,
  `customer_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKrvr6wl9gll7u98cda18smugp4` (`customer_id`),
  CONSTRAINT `FKrvr6wl9gll7u98cda18smugp4` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_addresses`
--

LOCK TABLES `customer_addresses` WRITE;
/*!40000 ALTER TABLE `customer_addresses` DISABLE KEYS */;
INSERT INTO `customer_addresses` VALUES (2,'Pallakad',_binary '','Pallakad',NULL,'248343','Kerala','HOME',50),(3,'',_binary '','',NULL,'','','HOME',52),(5,'',_binary '','',NULL,'','','HOME',54);
/*!40000 ALTER TABLE `customer_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `aadhaar_number` varchar(12) DEFAULT NULL,
  `alternate_phone` varchar(20) DEFAULT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `customer_code` varchar(20) NOT NULL,
  `customer_type` enum('INDIVIDUAL','CORPORATE') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `first_name` varchar(80) NOT NULL,
  `gender` enum('MALE','FEMALE','OTHER') DEFAULT NULL,
  `gst_number` varchar(20) DEFAULT NULL,
  `last_name` varchar(80) NOT NULL,
  `pan_number` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_iqv746oh5t5is1vr4p2nl79r6` (`customer_code`),
  KEY `IDXm3iom37efaxd5eucmxjqqcbe9` (`phone`),
  KEY `IDXrfbvkrffamfql7cjmen8v976v` (`email`),
  KEY `IDXehqkpf4aj011gxrnhdfau36d` (`dealer_id`),
  CONSTRAINT `FKqh11qe8l9tavgx2mto72afu6m` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,NULL,NULL,NULL,'2025-01-10 10:00:00.000000','CUST0001',NULL,NULL,'arvind@example.com','Arvind',NULL,NULL,'Narayanan',NULL,'9800000001','2026-03-26 21:29:00.696800',1,NULL,NULL),(2,NULL,NULL,NULL,'2025-01-15 11:30:00.000000','CUST0002',NULL,NULL,'sunita@example.com','Sunita',NULL,NULL,'Reddy',NULL,'9800000002','2026-03-26 21:29:00.698282',1,NULL,NULL),(3,NULL,NULL,NULL,'2025-02-20 14:15:00.000000','CUST0003',NULL,NULL,'rohan@example.com','Rohan',NULL,NULL,'Das',NULL,'9800000003','2026-03-26 21:29:00.698341',1,NULL,NULL),(4,NULL,NULL,NULL,'2025-03-05 09:45:00.000000','CUST0004',NULL,NULL,'kavya@example.com','Kavya',NULL,NULL,'Menon',NULL,'9800000004','2026-03-26 21:29:00.698395',1,NULL,NULL),(5,NULL,NULL,NULL,'2025-04-12 16:20:00.000000','CUST0005',NULL,NULL,'nitin@example.com','Nitin',NULL,NULL,'Shah',NULL,'9800000005','2026-03-26 21:29:00.698449',1,NULL,NULL),(6,NULL,NULL,NULL,'2025-05-18 10:15:00.000000','CUST0006',NULL,NULL,'meera.rao@example.com','Meera',NULL,NULL,'Rao',NULL,'9800000006','2026-03-26 21:29:00.698492',1,NULL,NULL),(7,NULL,NULL,NULL,'2025-06-22 11:45:00.000000','CUST0007',NULL,NULL,'sanjay.p@example.com','Sanjay',NULL,NULL,'Patil',NULL,'9800000007','2026-03-26 21:29:00.698549',1,NULL,NULL),(8,NULL,NULL,NULL,'2025-07-30 09:30:00.000000','CUST0008',NULL,NULL,'anjali.k@example.com','Anjali',NULL,NULL,'Kumar',NULL,'9800000008','2026-03-26 21:29:00.698603',1,NULL,NULL),(9,NULL,NULL,NULL,'2025-08-14 14:10:00.000000','CUST0009',NULL,NULL,'vikash.jain@example.com','Vikash',NULL,NULL,'Jain',NULL,'9800000009','2026-03-26 21:29:00.698650',1,NULL,NULL),(10,NULL,NULL,NULL,'2025-09-05 16:50:00.000000','CUST0010',NULL,NULL,'priya.c@example.com','Priya',NULL,NULL,'Chatterjee',NULL,'9800000010','2026-03-26 21:29:00.698694',1,NULL,NULL),(11,NULL,NULL,NULL,'2025-10-01 10:20:00.000000','CUST0011',NULL,NULL,'amit.d@example.com','Amit',NULL,NULL,'Dubey',NULL,'9800000011','2026-03-26 21:29:00.698736',1,NULL,NULL),(12,NULL,NULL,NULL,'2025-11-12 12:40:00.000000','CUST0012',NULL,NULL,'sneha.iyer@example.com','Sneha',NULL,NULL,'Iyer',NULL,'9800000012','2026-03-26 21:29:00.698789',1,NULL,NULL),(13,NULL,NULL,NULL,'2025-12-25 10:15:00.000000','CUST0013',NULL,NULL,'gaurav.m@example.com','Gaurav',NULL,NULL,'Mishra',NULL,'9800000013','2026-03-26 21:29:00.698831',1,NULL,NULL),(14,NULL,NULL,NULL,'2026-01-05 14:00:00.000000','CUST0014',NULL,NULL,'ritu.a@example.com','Ritu',NULL,NULL,'Agarwal',NULL,'9800000014','2026-03-26 21:29:00.698887',1,NULL,NULL),(15,NULL,NULL,NULL,'2026-02-18 09:00:00.000000','CUST0015',NULL,NULL,'tariq.k@example.com','Tariq',NULL,NULL,'Khan',NULL,'9800000015','2026-03-26 21:29:00.698925',1,NULL,NULL),(16,NULL,NULL,NULL,'2025-09-01 10:00:00.000000','CUST0016',NULL,NULL,'rahul.n@example.com','Rahul',NULL,NULL,'Nair',NULL,'9800000016','2026-03-26 21:29:00.699062',1,NULL,NULL),(17,NULL,NULL,NULL,'2025-09-05 11:30:00.000000','CUST0017',NULL,NULL,'kavita.s@example.com','Kavita',NULL,NULL,'Singh',NULL,'9800000017','2026-03-26 21:29:00.699139',1,NULL,NULL),(18,NULL,NULL,NULL,'2025-09-10 14:15:00.000000','CUST0018',NULL,NULL,'anita.r@example.com','Anita',NULL,NULL,'Reddy',NULL,'9800000018','2026-03-26 21:29:00.699182',1,NULL,NULL),(19,NULL,NULL,NULL,'2025-09-15 09:45:00.000000','CUST0019',NULL,NULL,'vijay.v@example.com','Vijay',NULL,NULL,'Verma',NULL,'9800000019','2026-03-26 21:29:00.699217',1,NULL,NULL),(20,NULL,NULL,NULL,'2025-09-20 16:20:00.000000','CUST0020',NULL,NULL,'sonia.g@example.com','Sonia',NULL,NULL,'Gupta',NULL,'9800000020','2026-03-26 21:29:00.699250',1,NULL,NULL),(21,NULL,NULL,NULL,'2025-10-01 10:15:00.000000','CUST0021',NULL,NULL,'deepak.s@example.com','Deepak',NULL,NULL,'Sharma',NULL,'9800000021','2026-03-26 21:29:00.699282',1,NULL,NULL),(22,NULL,NULL,NULL,'2025-10-05 11:45:00.000000','CUST0022',NULL,NULL,'riya.p@example.com','Riya',NULL,NULL,'Patil',NULL,'9800000022','2026-03-26 21:29:00.699315',1,NULL,NULL),(23,NULL,NULL,NULL,'2025-10-10 09:30:00.000000','CUST0023',NULL,NULL,'aman.k@example.com','Aman',NULL,NULL,'Kumar',NULL,'9800000023','2026-03-26 21:29:00.699348',1,NULL,NULL),(24,NULL,NULL,NULL,'2025-10-15 14:10:00.000000','CUST0024',NULL,NULL,'simran.j@example.com','Simran',NULL,NULL,'Jain',NULL,'9800000024','2026-03-26 21:29:00.699380',1,NULL,NULL),(25,NULL,NULL,NULL,'2025-10-20 16:50:00.000000','CUST0025',NULL,NULL,'naveen.c@example.com','Naveen',NULL,NULL,'Chatterjee',NULL,'9800000025','2026-03-26 21:29:00.699430',1,NULL,NULL),(26,NULL,NULL,NULL,'2025-11-01 10:20:00.000000','CUST0026',NULL,NULL,'meghna.d@example.com','Meghna',NULL,NULL,'Dubey',NULL,'9800000026','2026-03-26 21:29:00.699457',1,NULL,NULL),(27,NULL,NULL,NULL,'2025-11-05 12:40:00.000000','CUST0027',NULL,NULL,'karan.i@example.com','Karan',NULL,NULL,'Iyer',NULL,'9800000027','2026-03-26 21:29:00.699485',1,NULL,NULL),(28,NULL,NULL,NULL,'2025-11-10 10:15:00.000000','CUST0028',NULL,NULL,'puja.m@example.com','Puja',NULL,NULL,'Mishra',NULL,'9800000028','2026-03-26 21:29:00.699511',1,NULL,NULL),(29,NULL,NULL,NULL,'2025-11-15 14:00:00.000000','CUST0029',NULL,NULL,'rohit.a@example.com','Rohit',NULL,NULL,'Agarwal',NULL,'9800000029','2026-03-26 21:29:00.699541',1,NULL,NULL),(30,NULL,NULL,NULL,'2025-11-20 09:00:00.000000','CUST0030',NULL,NULL,'aisha.k@example.com','Aisha',NULL,NULL,'Khan',NULL,'9800000030','2026-03-26 21:29:00.699568',1,NULL,NULL),(31,NULL,NULL,NULL,'2025-12-01 10:00:00.000000','CUST0031',NULL,NULL,'ravi.m@example.com','Ravi',NULL,NULL,'Menon',NULL,'9800000031','2026-03-26 21:29:00.699593',1,NULL,NULL),(32,NULL,NULL,NULL,'2025-12-05 11:30:00.000000','CUST0032',NULL,NULL,'snehalata.r@example.com','Snehlata',NULL,NULL,'Rao',NULL,'9800000032','2026-03-26 21:29:00.699617',1,NULL,NULL),(33,NULL,NULL,NULL,'2025-12-10 14:15:00.000000','CUST0033',NULL,NULL,'arjun.d@example.com','Arjun',NULL,NULL,'Das',NULL,'9800000033','2026-03-26 21:29:00.699642',1,NULL,NULL),(34,NULL,NULL,NULL,'2025-12-15 09:45:00.000000','CUST0034',NULL,NULL,'divya.s@example.com','Divya',NULL,NULL,'Shah',NULL,'9800000034','2026-03-26 21:29:00.699666',1,NULL,NULL),(35,NULL,NULL,NULL,'2025-12-20 16:20:00.000000','CUST0035',NULL,NULL,'siddharth.b@example.com','Siddharth',NULL,NULL,'Bose',NULL,'9800000035','2026-03-26 21:29:00.699695',1,NULL,NULL),(36,NULL,NULL,NULL,'2026-01-01 10:15:00.000000','CUST0036',NULL,NULL,'nisha.t@example.com','Nisha',NULL,NULL,'Tiwari',NULL,'9800000036','2026-03-26 21:29:00.699721',1,NULL,NULL),(37,NULL,NULL,NULL,'2026-01-05 11:45:00.000000','CUST0037',NULL,NULL,'varun.y@example.com','Varun',NULL,NULL,'Yadav',NULL,'9800000037','2026-03-26 21:29:00.699745',1,NULL,NULL),(38,NULL,NULL,NULL,'2026-01-10 09:30:00.000000','CUST0038',NULL,NULL,'kajal.c@example.com','Kajal',NULL,NULL,'Chauhan',NULL,'9800000038','2026-03-26 21:29:00.699769',1,NULL,NULL),(39,NULL,NULL,NULL,'2026-01-15 14:10:00.000000','CUST0039',NULL,NULL,'harsh.p@example.com','Harsh',NULL,NULL,'Pandey',NULL,'9800000039','2026-03-26 21:29:00.699793',1,NULL,NULL),(40,NULL,NULL,NULL,'2026-01-20 16:50:00.000000','CUST0040',NULL,NULL,'tanvi.m@example.com','Tanvi',NULL,NULL,'Mukherjee',NULL,'9800000040','2026-03-26 21:29:00.699823',1,NULL,NULL),(41,NULL,NULL,NULL,'2026-02-01 10:20:00.000000','CUST0041',NULL,NULL,'gagan.s@example.com','Gagan',NULL,NULL,'Sinha',NULL,'9800000041','2026-03-26 21:29:00.699846',1,NULL,NULL),(42,NULL,NULL,NULL,'2026-02-05 12:40:00.000000','CUST0042',NULL,NULL,'swati.b@example.com','Swati',NULL,NULL,'Bhatia',NULL,'9800000042','2026-03-26 21:29:00.699873',1,NULL,NULL),(43,NULL,NULL,NULL,'2026-02-10 10:15:00.000000','CUST0043',NULL,NULL,'manish.s@example.com','Manish',NULL,NULL,'Saxena',NULL,'9800000043','2026-03-26 21:29:00.699900',1,NULL,NULL),(44,NULL,NULL,NULL,'2026-02-15 14:00:00.000000','CUST0044',NULL,NULL,'preeti.k@example.com','Preeti',NULL,NULL,'Kaur',NULL,'9800000044','2026-03-26 21:29:00.699927',1,NULL,NULL),(45,NULL,NULL,NULL,'2026-02-20 09:00:00.000000','CUST0045',NULL,NULL,'vikas.c@example.com','Vikas',NULL,NULL,'Chawla',NULL,'9800000045','2026-03-26 21:29:00.699958',1,NULL,NULL),(46,NULL,NULL,NULL,'2026-03-25 21:35:48.977489','CUST-L-48977','INDIVIDUAL',NULL,NULL,'Girish',NULL,NULL,'',NULL,'7907956075','2026-03-26 21:29:00.699992',1,NULL,NULL),(50,NULL,'','','2026-03-26 22:08:56.312729','CST-DLR06-0001','INDIVIDUAL',NULL,'','Test Abhi','MALE','','K','','71392379239','2026-03-26 22:08:56.312731',6,NULL,NULL),(51,NULL,NULL,NULL,'2026-03-26 22:45:30.161788','CUST-L-30161','INDIVIDUAL',NULL,NULL,'Giri',NULL,NULL,'',NULL,'7398492749','2026-03-26 22:45:30.161789',6,NULL,NULL),(52,NULL,'','','2026-03-27 22:44:46.072816','CST-DLR01-0048','INDIVIDUAL',NULL,'','Thivi',NULL,'','Kumar','','7907956075','2026-03-27 22:44:46.072818',1,NULL,NULL),(54,NULL,NULL,NULL,'2026-03-31 07:02:36.360226','CUST-L-56359','INDIVIDUAL',NULL,NULL,'Vijay','MALE',NULL,'Kumar',NULL,'7907956075','2026-03-31 07:02:50.658614',1,NULL,NULL),(55,NULL,NULL,NULL,'2026-04-01 10:00:00.000000','CUST-APR-001',NULL,NULL,'amit.k@gmail.com','Amit',NULL,NULL,'Kumar',NULL,'9876543210',NULL,1,NULL,NULL),(56,NULL,NULL,NULL,'2026-04-01 11:30:00.000000','CUST-APR-002',NULL,NULL,'sita.l@outlook.com','Sita',NULL,NULL,'Lakshmi',NULL,'9876543211',NULL,1,NULL,NULL),(57,NULL,NULL,NULL,'2026-04-01 14:00:00.000000','CUST-APR-003',NULL,NULL,'rajesh.p@yahoo.com','Rajesh',NULL,NULL,'Pillai',NULL,'9876543212',NULL,1,NULL,NULL),(58,NULL,NULL,NULL,'2026-04-01 16:45:00.000000','CUST-APR-004',NULL,NULL,'anjali.n@gmail.com','Anjali',NULL,NULL,'Nair',NULL,'9876543213',NULL,1,NULL,NULL),(59,NULL,NULL,NULL,'2026-04-02 09:15:00.000000','CUST-APR-005',NULL,NULL,'venkat.b@rediffmail.com','Venkatesh',NULL,NULL,'Babu',NULL,'9876543214',NULL,1,NULL,NULL),(60,NULL,NULL,NULL,'2026-04-01 10:00:00.000000','CUST-2026-001',NULL,NULL,'arjun.reddy@example.com','Arjun',NULL,NULL,'Reddy',NULL,'9876543210',NULL,1,NULL,NULL),(61,NULL,NULL,NULL,'2026-04-01 11:30:00.000000','CUST-2026-002',NULL,NULL,'lekha.m@example.com','Lekha',NULL,NULL,'Menon',NULL,'9876543211',NULL,1,NULL,NULL),(62,NULL,NULL,NULL,'2026-04-01 14:15:00.000000','CUST-2026-003',NULL,NULL,'v.prabhu@example.com','Vikram',NULL,NULL,'Prabhu',NULL,'9876543212',NULL,1,NULL,NULL),(63,NULL,NULL,NULL,'2026-04-01 16:45:00.000000','CUST-2026-004',NULL,NULL,'sanya.g@example.com','Sanya',NULL,NULL,'Gupta',NULL,'9876543213',NULL,1,NULL,NULL),(64,NULL,NULL,NULL,'2026-04-02 09:00:00.000000','CUST-2026-005',NULL,NULL,'karthik.s@example.com','Karthik',NULL,NULL,'S',NULL,'9876543214',NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dealer_registrations`
--

DROP TABLE IF EXISTS `dealer_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dealer_registrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` text,
  `admin_email` varchar(150) NOT NULL,
  `admin_full_name` varchar(150) NOT NULL,
  `admin_password_hash` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `contact_name` varchar(150) NOT NULL,
  `contact_phone` varchar(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `dealer_name` varchar(150) NOT NULL,
  `gst_number` varchar(20) DEFAULT NULL,
  `rejection_reason` text,
  `reviewed_at` datetime(6) DEFAULT NULL,
  `state` varchar(100) NOT NULL,
  `status` enum('PENDING','ACTIVE','DECLINED') NOT NULL,
  `dealer_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_rbac1tu38b8o5yyoc4wkgapgv` (`admin_email`),
  KEY `FK7n4ssm5u5w3vr1m6rg0lrtkwx` (`dealer_id`),
  CONSTRAINT `FK7n4ssm5u5w3vr1m6rg0lrtkwx` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dealer_registrations`
--

LOCK TABLES `dealer_registrations` WRITE;
/*!40000 ALTER TABLE `dealer_registrations` DISABLE KEYS */;
INSERT INTO `dealer_registrations` VALUES (2,'Chennai Main St','admin@hyundaidms.in','S Girish Kumar','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','Chennai','S Girish Kumar','9876543210','2026-03-26 21:49:27.000000','Hyundai Chennai','33AAAAA1234A1Z1',NULL,'2026-03-26 21:49:27.000000','Tamil Nadu','ACTIVE',1),(3,'Okhla Phase III','prachi_dms@gmail.com','Prachi Kumari','$2a$10$LbxjYDSDnllhP/tEjHx1MekmYdxV8AL7N8.LLT4Qd540HzewV8hdW','Delhi','Prachi Kumari','7907956075','2026-03-26 21:49:27.000000','Hyundai Delhi','07AAACH1234F1Z1',NULL,'2026-03-26 21:49:27.000000','Delhi','ACTIVE',2),(4,'Coimbatore','abhi_dms@gmail.com','Abhinav K','$2a$10$N08uzUhrebxIJIYzh9xvGewOYFmQbm04P/E/.4wLC52Fh1WGEdB4.','Coimbatore','Abhinav K','9446210744','2026-03-26 21:55:11.753820','Hyundai Coimbatore','',NULL,'2026-03-26 22:01:51.279866','Tamil Nadu','ACTIVE',6),(5,'','naren@gmail.com','Naren','$2a$10$5p1AtwK1.rlDq7AlVpk/ueyV2pO9ei6kcfdET34zXUcp2Bnu8ES2i','Redhills','Naren','7907956075','2026-03-27 23:26:18.650332','Hyundai Redhills','',NULL,'2026-03-27 23:26:44.764144','Tamil Nadu','ACTIVE',7);
/*!40000 ALTER TABLE `dealer_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dealers`
--

DROP TABLE IF EXISTS `dealers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dealers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` text,
  `city` varchar(100) NOT NULL,
  `contact_email` varchar(150) DEFAULT NULL,
  `contact_name` varchar(150) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `dealer_code` varchar(20) NOT NULL,
  `gst_number` varchar(20) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `state` varchar(100) NOT NULL,
  `status` enum('PENDING','ACTIVE','DECLINED','DEACTIVATED') NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `deactivated_at` datetime(6) DEFAULT NULL,
  `deactivated_by_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_aes1g37lf13g8dr94yjqwq6p1` (`dealer_code`),
  UNIQUE KEY `UK_3ch731qyywlniwmbvsk7ssnom` (`gst_number`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dealers`
--

LOCK TABLES `dealers` WRITE;
/*!40000 ALTER TABLE `dealers` DISABLE KEYS */;
INSERT INTO `dealers` VALUES (1,'Coimbatore','Chennai','admin@hyundaidms.in','S Girish Kumar','7907956075','2026-03-26 20:12:10.551618','DLR-CHE-001',NULL,'Hyundai Chennai','Tamil Nadu','ACTIVE','2026-03-26 20:12:10.551625',NULL,NULL),(2,'Plot 15, Okhla Phase III','Delhi','prachi_dms@gmail.com','Prachi Kumari','7907956075',NULL,'DLR-DEL-775','07AAACH1234F1Z1','Hyundai Delhi','Delhi','ACTIVE','2026-03-27 00:10:35.299870',NULL,NULL),(6,'Coimbatore','Coimbatore','abhi_dms@gmail.com','Abhinav K','9446210744','2026-03-26 22:01:51.196235','DLR-COI-1196',NULL,'Hyundai Coimbatore','Tamil Nadu','ACTIVE','2026-03-26 22:01:51.196236',NULL,NULL),(7,'','Redhills','naren@gmail.com','Naren','7907956075','2026-03-27 23:26:44.722488','DLR-RED-4720',NULL,'Hyundai Redhills','Tamil Nadu','ACTIVE','2026-03-28 12:57:38.097938',NULL,NULL);
/*!40000 ALTER TABLE `dealers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_j6cwks7xecs5jov19ro8ge3qk` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,NULL,NULL,'Management'),(2,NULL,NULL,'Sales'),(3,NULL,NULL,'Service'),(4,NULL,NULL,'Inventory'),(5,NULL,NULL,'Accounts'),(6,NULL,'Admin & HR','Administration');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_roles`
--

DROP TABLE IF EXISTS `employee_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_roles` (
  `employee_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`employee_id`,`role_id`),
  KEY `FK398vvu81xw154mvy3g2eytscn` (`role_id`),
  CONSTRAINT `FK398vvu81xw154mvy3g2eytscn` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FK3uwwaxeiucvfixgd45etkjgmg` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_roles`
--

LOCK TABLES `employee_roles` WRITE;
/*!40000 ALTER TABLE `employee_roles` DISABLE KEYS */;
INSERT INTO `employee_roles` VALUES (1,1),(2,2),(3,3),(4,3),(10,8);
/*!40000 ALTER TABLE `employee_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `date_of_join` date DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `employee_code` varchar(20) NOT NULL,
  `first_name` varchar(80) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `last_name` varchar(80) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `department_id` bigint NOT NULL,
  `manager_id` bigint DEFAULT NULL,
  `role_id` bigint NOT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `deactivated_at` datetime(6) DEFAULT NULL,
  `deactivated_by_name` varchar(255) DEFAULT NULL,
  `failed_login_attempts` int DEFAULT NULL,
  `is_locked` bit(1) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_j9xgmd0ya5jmus09o0b8pqrpb` (`email`),
  UNIQUE KEY `UK_etqhw9qqnad1kyjq3ks1glw8x` (`employee_code`),
  KEY `IDXhvs7qecyj0tfhgx75kdj0mxuk` (`department_id`),
  KEY `IDX4w3luja5yf4agc4pip3gkddv3` (`role_id`),
  KEY `IDX45wbbhq0opta7399k589pm8en` (`is_active`),
  KEY `FKi4365uo9af35g7jtbc2rteukt` (`manager_id`),
  KEY `FKtg0ain8x50fvk6rmg0agnldv6` (`dealer_id`),
  CONSTRAINT `FKah490190ww1q2a4piuv41hk6e` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FKgy4qe3dnqrm3ktd76sxp7n4c2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `FKi4365uo9af35g7jtbc2rteukt` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `FKtg0ain8x50fvk6rmg0agnldv6` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,NULL,'2020-01-15','admin@dealerconnect.com','EMP001','S',_binary '','GIRISH KUMAR','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543210','2026-04-04 19:44:21.985360',1,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,NULL,'2020-03-10','sales.mgr@dealerconnect.com','EMP002','Priya',_binary '','Sharma','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543211','2026-03-31 07:04:31.418839',2,NULL,2,1,NULL,NULL,0,_binary '\0',NULL,NULL,NULL),(3,NULL,'2021-06-01','rahul.sales@dealerconnect.com','EMP003','Rahul',_binary '','Verma','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543212','2026-03-27 23:25:16.593778',2,NULL,3,1,NULL,NULL,0,_binary '\0',NULL,NULL,NULL),(4,NULL,'2021-08-15','anita.sales@dealerconnect.com','EMP004','Anita',_binary '','Desai','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543213','2026-03-27 23:24:23.479704',2,NULL,3,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,NULL,'2020-11-20','vikram.svc@dealerconnect.com','EMP005','Vikram',_binary '','Singh','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543214','2026-03-26 21:07:36.961995',3,NULL,4,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,NULL,'2022-01-10','suresh.mech@dealerconnect.com','EMP006','Suresh',_binary '','Babu','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543215','2026-03-26 21:07:36.962047',3,NULL,5,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,NULL,'2022-02-15','ramesh.mech@dealerconnect.com','EMP007','Ramesh',_binary '','Kumar','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543216','2026-03-26 21:07:36.962089',3,NULL,5,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,NULL,'2023-01-05','karthik.sales@dealerconnect.com','EMP008','Karthik',_binary '','Nair','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543217','2026-03-26 21:07:36.962125',2,NULL,3,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,NULL,'2024-05-10','neha.inv@dealerconnect.com','EMP009','Neha',_binary '','Gupta','$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW','9876543218','2026-03-26 21:07:36.962178',4,NULL,6,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'2026-03-26 19:57:14.903584',NULL,'superadmin@dealerconnect.com','SA001','DMS',_binary '','SuperAdmin','$2a$10$XvhacGRPMsWhAlkEaf7e4ehLnRBfuZOtySYoFamAlky7aLXAkOWgm','9000000000','2026-04-04 19:59:36.005754',6,NULL,8,1,NULL,NULL,0,NULL,NULL,NULL,NULL),(11,'2026-03-26 20:12:10.654566',NULL,'prachi_dms@gmail.com','EMP011','Prachi',_binary '','Kumari','$2a$10$LbxjYDSDnllhP/tEjHx1MekmYdxV8AL7N8.LLT4Qd540HzewV8hdW','7907956075',NULL,6,NULL,1,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'2026-03-26 22:01:51.273512',NULL,'abhi_dms@gmail.com','DLR06-ADM','Abhinav',_binary '','K','$2a$10$N08uzUhrebxIJIYzh9xvGewOYFmQbm04P/E/.4wLC52Fh1WGEdB4.','9446210744',NULL,6,NULL,1,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'2026-03-26 23:30:54.657200','2026-03-26','giri_dms@gmail.com','EMP-DLR06-0002','Giri',_binary '\0','Kumar','$2a$10$kzY5oVlWYKbbcxVzBaDGK.0f3slv0SuVIm1wQWtfNGShREZKoMadu','4839493439','2026-03-26 23:44:20.552355',2,NULL,3,6,'2026-03-26 23:44:20.549603','Abhinav K',NULL,NULL,NULL,NULL,NULL),(16,'2026-03-26 23:48:57.483742','2026-03-26','giri__dms@gmail.com','EMP-DLR06-0003','Giri',_binary '\0','Kumar','$2a$10$mWikuqi7Nc3GKHEil6DDseuIWbGP8tV3Uz3Nb5nVh/7021s/Uxnxy','2379237293','2026-03-26 23:49:05.763844',2,NULL,3,6,'2026-03-26 23:49:05.761069','Abhinav K',NULL,NULL,NULL,NULL,NULL),(17,'2026-03-27 23:26:44.758626',NULL,'naren@gmail.com','DLR07-ADM','Naren',_binary '','-','$2a$10$5p1AtwK1.rlDq7AlVpk/ueyV2pO9ei6kcfdET34zXUcp2Bnu8ES2i','7907956075','2026-03-27 23:26:44.758627',6,NULL,1,7,NULL,NULL,0,_binary '\0',NULL,NULL,NULL);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engine_types`
--

DROP TABLE IF EXISTS `engine_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `engine_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fuel_category` varchar(30) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_4gcql7w0aw932rr7htutgjqim` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `engine_types`
--

LOCK TABLES `engine_types` WRITE;
/*!40000 ALTER TABLE `engine_types` DISABLE KEYS */;
INSERT INTO `engine_types` VALUES (1,'Petrol','1.2L Kappa Petrol'),(2,'Petrol','1.5L MPi Petrol'),(3,'Diesel','1.5L U2 CRDi Diesel'),(4,'Petrol','1.0L Turbo GDi'),(5,'EV','Permanent Magnet Sync Motor'),(6,'Petrol','2.0L Nu Petrol');
/*!40000 ALTER TABLE `engine_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finance_loans`
--

DROP TABLE IF EXISTS `finance_loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finance_loans` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `disbursal_date` date DEFAULT NULL,
  `emi_amount` decimal(10,2) DEFAULT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `loan_amount` decimal(12,2) NOT NULL,
  `loan_number` varchar(30) NOT NULL,
  `remarks` text,
  `status` enum('APPLIED','APPROVED','DISBURSED','REJECTED','CLOSED') DEFAULT NULL,
  `tenure_months` int NOT NULL,
  `bank_id` bigint NOT NULL,
  `booking_id` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_nlgol6inj6ehmxgfxd7mgur1r` (`loan_number`),
  KEY `IDXo4setx4rkifb27p4r29krx0b6` (`customer_id`),
  KEY `IDXqe9g94afl5rgy7ul0cnf3s43` (`status`),
  KEY `FKlaw3w5cw6q9q50elo1amrpywy` (`bank_id`),
  KEY `FKo7i63hd2w3ck43g0hm8wj8l9q` (`booking_id`),
  CONSTRAINT `FK4nxnc0qno27b1nlnth36l58m5` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `FKlaw3w5cw6q9q50elo1amrpywy` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
  CONSTRAINT `FKo7i63hd2w3ck43g0hm8wj8l9q` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finance_loans`
--

LOCK TABLES `finance_loans` WRITE;
/*!40000 ALTER TABLE `finance_loans` DISABLE KEYS */;
/*!40000 ALTER TABLE `finance_loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_locations`
--

DROP TABLE IF EXISTS `inventory_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_locations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `dealer_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_7iritpmu1a0rd1kp1joo9ys0` (`name`),
  KEY `FKnf1tu368113tuuael0jyeob7v` (`dealer_id`),
  CONSTRAINT `FKnf1tu368113tuuael0jyeob7v` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_locations`
--

LOCK TABLES `inventory_locations` WRITE;
/*!40000 ALTER TABLE `inventory_locations` DISABLE KEYS */;
INSERT INTO `inventory_locations` VALUES (1,'Block A, City Center','Main Showroom',1),(2,'Industrial Area Phase 1','City Warehouse',1),(3,'Behind Showroom','Service Center Stock',1),(4,'Outskirts Storage Facility','Yard B',1);
/*!40000 ALTER TABLE `inventory_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `gst_amount` decimal(10,2) DEFAULT NULL,
  `invoice_date` date NOT NULL,
  `invoice_number` varchar(20) NOT NULL,
  `status` enum('DRAFT','ISSUED','PAID','CANCELLED') DEFAULT NULL,
  `sub_total` decimal(12,2) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `booking_id` bigint NOT NULL,
  `created_by` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `vehicle_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_l1x55mfsay7co0r3m9ynvipd5` (`invoice_number`),
  UNIQUE KEY `UK_qn380ix1ge287r0rd8th12bwi` (`booking_id`),
  KEY `IDXrgk46wvvdvosguudhjgow7fa9` (`customer_id`),
  KEY `IDXfflhj226dcw7qfevlvmh2vfsg` (`invoice_date`),
  KEY `IDXq11xedrmax65vyfuevlmuj2h8` (`status`),
  KEY `FKiishphl6tq3o746rl8g9d6tlp` (`created_by`),
  KEY `FK6rtyulrbvhhnm9fkxuxau40qk` (`vehicle_id`),
  CONSTRAINT `FK6rtyulrbvhhnm9fkxuxau40qk` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  CONSTRAINT `FKb9bhb7xre5v64qvjeholh3qj0` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `FKiishphl6tq3o746rl8g9d6tlp` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`),
  CONSTRAINT `FKq2w4hmh6l9othnp6cepp0cfe2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,'2026-04-01 16:15:00.000000',NULL,'2026-04-01','INV-2026-04-001','PAID',1850000.00,2150000.00,69,1,62,108),(2,'2026-04-02 11:00:00.000000',NULL,'2026-04-02','INV-2026-04-002','ISSUED',794000.00,920000.00,68,1,60,109);
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_cards`
--

DROP TABLE IF EXISTS `job_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_cards` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `job_card_no` varchar(20) NOT NULL,
  `appointment_id` bigint DEFAULT NULL,
  `mechanic_id` bigint DEFAULT NULL,
  `odometer_in` int DEFAULT NULL,
  `odometer_out` int DEFAULT NULL,
  `diagnosis` text,
  `repair_details` text,
  `labour_cost` decimal(10,2) DEFAULT '0.00',
  `parts_cost` decimal(10,2) DEFAULT '0.00',
  `total_cost` decimal(10,2) DEFAULT '0.00',
  `status` enum('OPEN','IN_PROGRESS','PENDING_PARTS','COMPLETED','BILLED') DEFAULT 'OPEN',
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `job_card_no` (`job_card_no`),
  UNIQUE KEY `appointment_id` (`appointment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_cards`
--

LOCK TABLES `job_cards` WRITE;
/*!40000 ALTER TABLE `job_cards` DISABLE KEYS */;
INSERT INTO `job_cards` VALUES (1,'JC-202603-01',NULL,1,NULL,NULL,NULL,NULL,0.00,0.00,4500.00,'IN_PROGRESS',NULL,NULL,'2026-03-30 16:23:51','2026-03-30 16:23:51'),(2,'JC-202603-02',NULL,2,NULL,NULL,NULL,NULL,0.00,0.00,8200.00,'OPEN',NULL,NULL,'2026-03-30 16:23:51','2026-03-30 16:23:51'),(3,'JC-202603-03',NULL,1,NULL,NULL,NULL,NULL,0.00,0.00,2500.00,'PENDING_PARTS',NULL,NULL,'2026-03-30 16:23:51','2026-03-30 16:23:51'),(4,'JC-202603-04',NULL,2,NULL,NULL,NULL,NULL,0.00,0.00,3000.00,'COMPLETED',NULL,NULL,'2026-03-30 16:23:51','2026-03-30 16:23:51'),(5,'JC-202603-05',NULL,1,NULL,NULL,NULL,NULL,0.00,0.00,12000.00,'BILLED',NULL,NULL,'2026-03-30 16:23:51','2026-03-30 16:23:51');
/*!40000 ALTER TABLE `job_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_sources`
--

DROP TABLE IF EXISTS `lead_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_sources` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_dct1vs4jvia7r6doqusdvugeu` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_sources`
--

LOCK TABLES `lead_sources` WRITE;
/*!40000 ALTER TABLE `lead_sources` DISABLE KEYS */;
INSERT INTO `lead_sources` VALUES (5,'Call Center'),(3,'Referral'),(1,'Showroom Walk-in'),(4,'Social Media'),(2,'Website');
/*!40000 ALTER TABLE `lead_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads`
--

DROP TABLE IF EXISTS `leads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leads` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `expected_close_date` date DEFAULT NULL,
  `lead_number` varchar(20) NOT NULL,
  `remarks` text,
  `status` enum('NEW','CONTACTED','TEST_DRIVE','NEGOTIATION','BOOKED','LOST','DELIVERED') DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `assigned_to` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `preferred_color_id` bigint DEFAULT NULL,
  `preferred_model_id` bigint DEFAULT NULL,
  `preferred_variant_id` bigint DEFAULT NULL,
  `source_id` bigint NOT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dealer_lead_number` (`dealer_id`,`lead_number`),
  KEY `IDXm7qdrai4inxcl00vijg1j1cpx` (`status`),
  KEY `IDXj5s5osti6jlrmu7o0sy1graxv` (`assigned_to`),
  KEY `IDX8v5pbwh0tgrqrlwt7u977gasa` (`customer_id`),
  KEY `FKmsdoui0x5dh4u4kgtktobobjb` (`preferred_color_id`),
  KEY `FKfujns1qww841lu9xsp69drq8k` (`preferred_model_id`),
  KEY `FKt2dfwdrbdpnd6kgm7phfsk4fn` (`preferred_variant_id`),
  KEY `FK5q2k3ehl603xllc15kpx1mcjy` (`source_id`),
  KEY `IDX1xxeekbunq5nhglqbsknhs8ft` (`dealer_id`),
  CONSTRAINT `FK5q2k3ehl603xllc15kpx1mcjy` FOREIGN KEY (`source_id`) REFERENCES `lead_sources` (`id`),
  CONSTRAINT `FKdjm652bjnmgf3va6xy7fsnwkn` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`),
  CONSTRAINT `FKfujns1qww841lu9xsp69drq8k` FOREIGN KEY (`preferred_model_id`) REFERENCES `vehicle_models` (`id`),
  CONSTRAINT `FKiv0byuc79q4r0ynxhsw300xbt` FOREIGN KEY (`assigned_to`) REFERENCES `employees` (`id`),
  CONSTRAINT `FKmsdoui0x5dh4u4kgtktobobjb` FOREIGN KEY (`preferred_color_id`) REFERENCES `colors` (`id`),
  CONSTRAINT `FKt2dfwdrbdpnd6kgm7phfsk4fn` FOREIGN KEY (`preferred_variant_id`) REFERENCES `vehicle_variants` (`id`),
  CONSTRAINT `FKtha9i86g8pjibocaxfvy8iysu` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads`
--

LOCK TABLES `leads` WRITE;
/*!40000 ALTER TABLE `leads` DISABLE KEYS */;
INSERT INTO `leads` VALUES (1,'2025-09-12 10:30:00.000000',NULL,'LD0001',NULL,'BOOKED','2026-03-26 21:29:00.811389',3,1,NULL,NULL,1,1,1,NULL,NULL),(2,'2025-10-16 11:00:00.000000',NULL,'LD0002',NULL,'CONTACTED','2026-03-26 21:29:00.811441',3,2,NULL,NULL,4,2,1,NULL,NULL),(3,'2025-11-22 15:00:00.000000',NULL,'LD0003',NULL,'TEST_DRIVE','2026-03-26 21:29:00.811468',4,3,NULL,NULL,2,3,1,NULL,NULL),(4,'2025-12-06 10:00:00.000000',NULL,'LD0004',NULL,'BOOKED','2026-03-26 21:29:00.811484',4,4,NULL,NULL,6,1,1,NULL,NULL),(5,'2026-01-13 14:30:00.000000',NULL,'LD0005',NULL,'NEGOTIATION','2026-03-26 21:29:00.811499',3,5,NULL,NULL,8,2,1,NULL,NULL),(6,'2026-02-15 10:15:00.000000',NULL,'LD0006',NULL,'NEW','2026-03-26 21:29:00.811521',8,6,NULL,NULL,9,4,1,NULL,NULL),(7,'2025-09-05 16:30:00.000000',NULL,'LD0007',NULL,'LOST','2026-03-26 21:29:00.811539',8,7,NULL,NULL,10,5,1,NULL,NULL),(8,'2025-10-20 11:00:00.000000',NULL,'LD0008',NULL,'BOOKED','2026-03-26 21:29:00.811553',3,8,NULL,NULL,12,1,1,NULL,NULL),(9,'2025-11-10 14:00:00.000000',NULL,'LD0009',NULL,'TEST_DRIVE','2026-03-26 21:29:00.811572',4,9,NULL,NULL,5,2,1,NULL,NULL),(10,'2025-12-15 10:45:00.000000',NULL,'LD0010',NULL,'BOOKED','2026-03-26 21:29:00.811587',8,10,NULL,NULL,7,3,1,NULL,NULL),(11,'2026-01-20 09:30:00.000000',NULL,'LD0011',NULL,'NEW','2026-03-26 21:29:00.811600',3,11,NULL,NULL,3,4,1,NULL,NULL),(12,'2026-02-05 15:20:00.000000',NULL,'LD0012',NULL,'BOOKED','2026-03-26 21:29:00.811615',4,12,NULL,NULL,2,1,1,NULL,NULL),(13,'2026-02-28 11:10:00.000000',NULL,'LD0013',NULL,'NEGOTIATION','2026-03-26 21:29:00.811629',8,13,NULL,NULL,1,2,1,NULL,NULL),(14,'2026-03-05 10:00:00.000000',NULL,'LD0014',NULL,'CONTACTED','2026-03-26 21:29:00.811643',3,14,NULL,NULL,4,5,1,NULL,NULL),(15,'2026-03-10 14:15:00.000000',NULL,'LD0015',NULL,'TEST_DRIVE','2026-03-26 21:29:00.811658',4,15,NULL,NULL,8,3,1,NULL,NULL),(16,'2025-09-02 10:30:00.000000',NULL,'LD0016',NULL,'BOOKED','2026-03-26 21:29:00.811778',3,16,NULL,NULL,5,1,1,NULL,NULL),(17,'2025-09-06 11:00:00.000000',NULL,'LD0017',NULL,'CONTACTED','2026-03-26 21:29:00.811805',4,17,NULL,NULL,1,2,1,NULL,NULL),(18,'2025-09-11 15:00:00.000000',NULL,'LD0018',NULL,'TEST_DRIVE','2026-03-26 21:29:00.811822',8,18,NULL,NULL,3,3,1,NULL,NULL),(19,'2025-09-16 10:00:00.000000',NULL,'LD0019',NULL,'BOOKED','2026-03-26 21:29:00.811837',3,19,NULL,NULL,2,4,1,NULL,NULL),(20,'2025-09-21 14:30:00.000000',NULL,'LD0020',NULL,'NEGOTIATION','2026-03-26 21:29:00.811851',4,20,NULL,NULL,6,5,1,NULL,NULL),(21,'2025-10-02 10:15:00.000000',NULL,'LD0021',NULL,'NEW','2026-03-26 21:29:00.811866',8,21,NULL,NULL,4,1,1,NULL,NULL),(22,'2025-10-06 16:30:00.000000',NULL,'LD0022',NULL,'LOST','2026-03-26 21:29:00.811880',3,22,NULL,NULL,8,2,1,NULL,NULL),(23,'2025-10-11 11:00:00.000000',NULL,'LD0023',NULL,'BOOKED','2026-03-26 21:29:00.811893',4,23,NULL,NULL,7,3,1,NULL,NULL),(24,'2025-10-16 14:00:00.000000',NULL,'LD0024',NULL,'TEST_DRIVE','2026-03-26 21:29:00.811907',8,24,NULL,NULL,5,4,1,NULL,NULL),(25,'2025-10-21 10:45:00.000000',NULL,'LD0025',NULL,'BOOKED','2026-03-26 21:29:00.811921',3,25,NULL,NULL,1,5,1,NULL,NULL),(26,'2025-11-02 09:30:00.000000',NULL,'LD0026',NULL,'NEW','2026-03-26 21:29:00.811935',4,26,NULL,NULL,3,1,1,NULL,NULL),(27,'2025-11-06 15:20:00.000000',NULL,'LD0027',NULL,'BOOKED','2026-03-26 21:29:00.811949',8,27,NULL,NULL,2,2,1,NULL,NULL),(28,'2025-11-11 11:10:00.000000',NULL,'LD0028',NULL,'NEGOTIATION','2026-03-26 21:29:00.811962',3,28,NULL,NULL,6,3,1,NULL,NULL),(29,'2025-11-16 10:00:00.000000',NULL,'LD0029',NULL,'CONTACTED','2026-03-26 21:29:00.811976',4,29,NULL,NULL,4,4,1,NULL,NULL),(30,'2025-11-21 14:15:00.000000',NULL,'LD0030',NULL,'TEST_DRIVE','2026-03-26 21:29:00.811991',8,30,NULL,NULL,8,5,1,NULL,NULL),(31,'2025-12-02 10:30:00.000000',NULL,'LD0031',NULL,'BOOKED','2026-03-26 21:29:00.812005',3,31,NULL,NULL,7,1,1,NULL,NULL),(32,'2025-12-06 11:00:00.000000',NULL,'LD0032',NULL,'CONTACTED','2026-03-26 21:29:00.812019',4,32,NULL,NULL,5,2,1,NULL,NULL),(33,'2025-12-11 15:00:00.000000',NULL,'LD0033',NULL,'TEST_DRIVE','2026-03-26 21:29:00.812033',8,33,NULL,NULL,1,3,1,NULL,NULL),(34,'2025-12-16 10:00:00.000000',NULL,'LD0034',NULL,'BOOKED','2026-03-26 21:29:00.812047',3,34,NULL,NULL,3,4,1,NULL,NULL),(35,'2025-12-21 14:30:00.000000',NULL,'LD0035',NULL,'NEGOTIATION','2026-03-26 21:29:00.812061',4,35,NULL,NULL,2,5,1,NULL,NULL),(36,'2026-01-02 10:15:00.000000',NULL,'LD0036',NULL,'NEW','2026-03-26 21:29:00.812076',8,36,NULL,NULL,6,1,1,NULL,NULL),(37,'2026-01-06 16:30:00.000000',NULL,'LD0037',NULL,'LOST','2026-03-26 21:29:00.812091',3,37,NULL,NULL,4,2,1,NULL,NULL),(38,'2026-01-11 11:00:00.000000',NULL,'LD0038',NULL,'BOOKED','2026-03-26 21:29:00.812104',4,38,NULL,NULL,8,3,1,NULL,NULL),(39,'2026-01-16 14:00:00.000000',NULL,'LD0039',NULL,'TEST_DRIVE','2026-03-26 21:29:00.812119',8,39,NULL,NULL,7,4,1,NULL,NULL),(40,'2026-01-21 10:45:00.000000',NULL,'LD0040',NULL,'BOOKED','2026-03-26 21:29:00.812133',3,40,NULL,NULL,5,5,1,NULL,NULL),(41,'2026-02-02 09:30:00.000000',NULL,'LD0041',NULL,'NEW','2026-03-26 21:29:00.812147',4,41,NULL,NULL,1,1,1,NULL,NULL),(42,'2026-02-06 15:20:00.000000',NULL,'LD0042',NULL,'BOOKED','2026-03-26 21:29:00.812160',8,42,NULL,NULL,3,2,1,NULL,NULL),(43,'2026-02-11 11:10:00.000000',NULL,'LD0043',NULL,'NEGOTIATION','2026-03-26 21:29:00.812175',3,43,NULL,NULL,2,3,1,NULL,NULL),(44,'2026-02-16 10:00:00.000000',NULL,'LD0044',NULL,'CONTACTED','2026-03-26 21:29:00.812189',4,44,NULL,NULL,6,4,1,NULL,NULL),(45,'2026-02-21 14:15:00.000000',NULL,'LD0045',NULL,'TEST_DRIVE','2026-03-26 21:29:00.812203',8,45,NULL,NULL,4,5,1,NULL,NULL),(46,'2026-03-01 10:00:00.000000',NULL,'LD0046',NULL,'NEW','2026-03-26 21:29:00.812217',3,1,NULL,NULL,1,1,1,NULL,NULL),(47,'2026-03-02 11:30:00.000000',NULL,'LD0047',NULL,'CONTACTED','2026-03-26 21:29:00.812230',4,2,NULL,NULL,3,2,1,NULL,NULL),(48,'2026-03-05 14:15:00.000000',NULL,'LD0048',NULL,'TEST_DRIVE','2026-03-26 21:29:00.812244',8,3,NULL,NULL,2,3,1,NULL,NULL),(49,'2026-03-10 09:45:00.000000',NULL,'LD0049',NULL,'CONTACTED','2026-03-26 21:29:00.812258',3,4,NULL,NULL,6,1,1,NULL,NULL),(50,'2026-03-12 16:20:00.000000',NULL,'LD0050',NULL,'NEW','2026-03-26 21:29:00.812272',4,5,NULL,NULL,12,2,1,NULL,NULL),(51,NULL,NULL,'BL26-001',NULL,'DELIVERED','2026-03-26 21:29:00.812286',3,1,NULL,NULL,3,1,1,NULL,NULL),(52,NULL,NULL,'BL26-002',NULL,'DELIVERED','2026-03-26 21:29:00.812336',4,2,NULL,NULL,6,2,1,NULL,NULL),(53,NULL,NULL,'BL26-003',NULL,'DELIVERED','2026-03-26 21:29:00.812351',8,3,NULL,NULL,9,3,1,NULL,NULL),(54,NULL,NULL,'BL26-004',NULL,'DELIVERED','2026-03-26 21:29:00.812364',3,4,NULL,NULL,10,1,1,NULL,NULL),(55,NULL,NULL,'BL26-005',NULL,'DELIVERED','2026-03-26 21:29:00.812383',4,5,NULL,NULL,11,2,1,NULL,NULL),(56,NULL,NULL,'BL26-006',NULL,'DELIVERED','2026-03-26 21:29:00.812398',8,6,NULL,NULL,3,3,1,NULL,NULL),(57,NULL,NULL,'BL26-007',NULL,'DELIVERED','2026-03-26 21:29:00.812413',3,7,NULL,NULL,6,1,1,NULL,NULL),(58,NULL,NULL,'BL26-008',NULL,'DELIVERED','2026-03-26 21:29:00.812427',4,8,NULL,NULL,9,2,1,NULL,NULL),(59,NULL,NULL,'BL26-009',NULL,'DELIVERED','2026-03-26 21:29:00.812441',8,9,NULL,NULL,10,3,1,NULL,NULL),(60,NULL,NULL,'BL26-010',NULL,'DELIVERED','2026-03-26 21:29:00.812458',3,10,NULL,NULL,11,1,1,NULL,NULL),(61,NULL,NULL,'BL26-011',NULL,'DELIVERED','2026-03-26 21:29:00.812474',4,1,NULL,NULL,3,2,1,NULL,NULL),(62,NULL,NULL,'BL26-012',NULL,'DELIVERED','2026-03-26 21:29:00.812489',8,2,NULL,NULL,6,3,1,NULL,NULL),(63,NULL,NULL,'BL26-013',NULL,'DELIVERED','2026-03-26 21:29:00.812503',3,3,NULL,NULL,9,1,1,NULL,NULL),(64,NULL,NULL,'BL26-014',NULL,'DELIVERED','2026-03-26 21:29:00.812529',4,4,NULL,NULL,10,2,1,NULL,NULL),(65,NULL,NULL,'BL26-015',NULL,'DELIVERED','2026-03-26 21:29:00.812546',8,5,NULL,NULL,11,3,1,NULL,NULL),(66,NULL,NULL,'BL26-016',NULL,'DELIVERED','2026-03-26 21:29:00.812565',3,6,NULL,NULL,3,1,1,NULL,NULL),(67,NULL,NULL,'BL26-017',NULL,'DELIVERED','2026-03-26 21:29:00.812584',4,7,NULL,NULL,6,2,1,NULL,NULL),(68,NULL,NULL,'BL26-018',NULL,'DELIVERED','2026-03-26 21:29:00.812599',8,8,NULL,NULL,9,3,1,NULL,NULL),(69,NULL,NULL,'BL26-019',NULL,'DELIVERED','2026-03-26 21:29:00.812613',3,9,NULL,NULL,10,1,1,NULL,NULL),(70,NULL,NULL,'BL26-020',NULL,'DELIVERED','2026-03-26 21:29:00.812627',4,10,NULL,NULL,11,2,1,NULL,NULL),(71,NULL,NULL,'BL26-021',NULL,'DELIVERED','2026-03-26 21:29:00.812640',8,1,NULL,NULL,3,3,1,NULL,NULL),(72,NULL,NULL,'BL26-022',NULL,'DELIVERED','2026-03-26 21:29:00.812653',3,2,NULL,NULL,6,1,1,NULL,NULL),(73,NULL,NULL,'BL26-023',NULL,'DELIVERED','2026-03-26 21:29:00.812670',4,3,NULL,NULL,9,2,1,NULL,NULL),(74,NULL,NULL,'BL26-024',NULL,'DELIVERED','2026-03-26 21:29:00.812685',8,4,NULL,NULL,10,3,1,NULL,NULL),(75,NULL,NULL,'BL26-025',NULL,'DELIVERED','2026-03-26 21:29:00.812698',3,5,NULL,NULL,11,1,1,NULL,NULL),(76,NULL,NULL,'BL26-026',NULL,'BOOKED','2026-03-26 21:29:00.812713',4,6,NULL,NULL,3,2,1,NULL,NULL),(77,NULL,NULL,'BL26-027',NULL,'BOOKED','2026-03-26 21:29:00.812726',8,7,NULL,NULL,6,3,1,NULL,NULL),(78,NULL,NULL,'BL26-028',NULL,'BOOKED','2026-03-26 21:29:00.812740',3,8,NULL,NULL,9,1,1,NULL,NULL),(79,NULL,NULL,'BL26-029',NULL,'BOOKED','2026-03-26 21:29:00.812754',4,9,NULL,NULL,10,2,1,NULL,NULL),(80,NULL,NULL,'BL26-030',NULL,'BOOKED','2026-03-26 21:29:00.812767',8,10,NULL,NULL,11,3,1,NULL,NULL),(81,NULL,NULL,'BL26-031',NULL,'BOOKED','2026-03-26 21:29:00.812783',3,1,NULL,NULL,3,1,1,NULL,NULL),(82,NULL,NULL,'BL26-032',NULL,'BOOKED','2026-03-26 21:29:00.812809',4,2,NULL,NULL,6,2,1,NULL,NULL),(83,NULL,NULL,'BL26-033',NULL,'BOOKED','2026-03-26 21:29:00.812823',8,3,NULL,NULL,9,3,1,NULL,NULL),(84,NULL,NULL,'BL26-034',NULL,'BOOKED','2026-03-26 21:29:00.812837',3,4,NULL,NULL,10,1,1,NULL,NULL),(85,NULL,NULL,'BL26-035',NULL,'BOOKED','2026-03-26 21:29:00.812850',4,5,NULL,NULL,11,2,1,NULL,NULL),(112,'2026-03-26 22:45:09.419618',NULL,'LD0001','','NEW','2026-03-26 22:45:09.419630',12,50,NULL,NULL,NULL,3,6,NULL,NULL),(114,'2026-03-31 07:02:36.404118','2026-04-15','LD0051','He is very interested in creta.','NEW','2026-03-31 07:02:36.404119',1,54,2,1,1,5,1,NULL,NULL),(115,'2026-04-01 10:15:00.000000',NULL,'LD-2026-001',NULL,'NEGOTIATION',NULL,3,60,NULL,1,NULL,1,1,NULL,NULL),(116,'2026-04-01 12:00:00.000000',NULL,'LD-2026-002',NULL,'CONTACTED',NULL,4,61,NULL,2,NULL,2,1,NULL,NULL),(117,'2026-04-01 14:30:00.000000',NULL,'LD-2026-003',NULL,'TEST_DRIVE',NULL,8,62,NULL,3,NULL,3,1,NULL,NULL),(118,'2026-04-01 17:00:00.000000',NULL,'LD-2026-004',NULL,'NEW',NULL,3,63,NULL,4,NULL,4,1,NULL,NULL),(119,'2026-04-02 09:30:00.000000',NULL,'LD-2026-005',NULL,'BOOKED',NULL,4,64,NULL,5,NULL,2,1,NULL,NULL);
/*!40000 ALTER TABLE `leads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mechanics`
--

DROP TABLE IF EXISTS `mechanics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mechanics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `speciality` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mechanics`
--

LOCK TABLES `mechanics` WRITE;
/*!40000 ALTER TABLE `mechanics` DISABLE KEYS */;
INSERT INTO `mechanics` VALUES (1,6,'General Engine Repair'),(2,7,'General Engine Repair');
/*!40000 ALTER TABLE `mechanics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_pnvtwliis6p05pn6i3ndjrqt2` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'View Customers, Leads, Bookings','SALES_VIEW'),(2,'Create Leads, Bookings','SALES_CREATE'),(3,'Edit Customers, Leads, Bookings','SALES_EDIT'),(4,'Delete Sales Records','SALES_DELETE'),(5,'View Vehicles','INVENTORY_VIEW'),(6,'Add Vehicles','INVENTORY_CREATE'),(7,'Edit Vehicles','INVENTORY_EDIT'),(8,'Delete Vehicles','INVENTORY_DELETE'),(9,'View Service Records','SERVICE_VIEW'),(10,'Create Appointments','SERVICE_CREATE'),(11,'Edit Service Status','SERVICE_EDIT'),(12,'Delete Service Records','SERVICE_DELETE'),(13,'View Parts','PARTS_VIEW'),(14,'Add Parts','PARTS_CREATE'),(15,'Edit Parts','PARTS_EDIT'),(16,'Delete Parts','PARTS_DELETE'),(17,'View Staff','EMPLOYEES_VIEW'),(18,'Add Staff','EMPLOYEES_CREATE'),(19,'Edit Staff','EMPLOYEES_EDIT'),(20,'Delete Staff','EMPLOYEES_DELETE'),(21,'View Reports','REPORTS_VIEW');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `FKegdk29eiy7mdtefy5c7eirr6e` (`permission_id`),
  CONSTRAINT `FKegdk29eiy7mdtefy5c7eirr6e` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `FKn5fotdgk8d1xvo8nav9uv3muc` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1),(2,1),(3,1),(4,1),(7,1),(1,2),(3,2),(1,3),(3,3),(7,3),(1,4),(3,4),(1,5),(2,5),(3,5),(4,5),(6,5),(1,6),(6,6),(1,7),(6,7),(1,8),(6,8),(1,9),(4,9),(5,9),(7,9),(1,10),(4,10),(1,11),(4,11),(5,11),(1,12),(1,13),(4,13),(5,13),(6,13),(7,13),(1,14),(4,14),(6,14),(1,15),(4,15),(6,15),(1,16),(4,16),(1,17),(2,17),(3,17),(1,18),(1,19),(1,20),(1,21),(2,21),(3,21),(4,21),(5,21),(6,21),(7,21);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ofx66keruapi6vyqpv6f2or37` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,NULL,'System Administrator','ADMIN'),(2,NULL,'Sales Manager','SALES_MANAGER'),(3,NULL,'Sales Executive','SALES_EXECUTIVE'),(4,NULL,'Service Advisor','SERVICE_ADVISOR'),(5,NULL,'Mechanic','MECHANIC'),(6,NULL,'Inventory Manager','INVENTORY_MANAGER'),(7,NULL,'Accounts & Finance','ACCOUNTS'),(8,'2026-03-26 19:57:14.765152','DMS Platform Administrator','SUPER_ADMIN');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_appointments`
--

DROP TABLE IF EXISTS `service_appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_appointments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `appointment_date` datetime(6) NOT NULL,
  `appointment_no` varchar(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `remarks` text,
  `service_type` enum('PERIODIC','REPAIR','ACCIDENTAL','WARRANTY','RECALL') NOT NULL,
  `status` enum('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED') DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `vehicle_reg_no` varchar(20) NOT NULL,
  `appointed_by` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `vehicle_variant_id` bigint DEFAULT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_gi716cjb7m2cphukria0sxem6` (`appointment_no`),
  KEY `IDX4ib89m4a2cqpu1q6qy0qprf32` (`customer_id`),
  KEY `IDXcwfiu8e6c3tsd9ajnf96f45vw` (`appointment_date`),
  KEY `IDX6x701nl9e2kupmlpjne6vjej5` (`status`),
  KEY `FKa5u4dnprrpwtdpwn4do80708p` (`appointed_by`),
  KEY `FKerl3stojgwinp0v3ba4eky1k7` (`vehicle_variant_id`),
  KEY `IDXs4itwn3i503l19s7b4chp0jun` (`dealer_id`),
  CONSTRAINT `FKa5u4dnprrpwtdpwn4do80708p` FOREIGN KEY (`appointed_by`) REFERENCES `employees` (`id`),
  CONSTRAINT `FKcxh78005ufl3tieydr4yokt2v` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`),
  CONSTRAINT `FKerl3stojgwinp0v3ba4eky1k7` FOREIGN KEY (`vehicle_variant_id`) REFERENCES `vehicle_variants` (`id`),
  CONSTRAINT `FKpeql9q693q8joibl36lc0cp1e` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_appointments`
--

LOCK TABLES `service_appointments` WRITE;
/*!40000 ALTER TABLE `service_appointments` DISABLE KEYS */;
INSERT INTO `service_appointments` VALUES (1,'2025-10-15 10:00:00.000000','SRV0001','2025-10-10 10:00:00.000000',NULL,'PERIODIC','COMPLETED','2026-03-26 21:29:01.050723','KA01AB1234',5,1,NULL,1,NULL,NULL),(2,'2025-11-20 14:00:00.000000','SRV0002','2025-11-18 10:00:00.000000',NULL,'REPAIR','IN_PROGRESS','2026-03-26 21:29:01.050774','KA03CD5678',5,2,NULL,1,NULL,NULL),(3,'2025-12-05 09:30:00.000000','SRV0003','2025-12-01 10:00:00.000000',NULL,'ACCIDENTAL','COMPLETED','2026-03-26 21:29:01.050796','KA05EF9012',5,3,NULL,1,NULL,NULL),(4,'2026-01-10 11:00:00.000000','SRV0004','2026-01-05 10:00:00.000000',NULL,'WARRANTY','COMPLETED','2026-03-26 21:29:01.050816','KA02GH3456',5,4,NULL,1,NULL,NULL),(5,'2026-02-25 10:30:00.000000','SRV0005','2026-02-20 10:00:00.000000',NULL,'PERIODIC','SCHEDULED','2026-03-26 21:29:01.050836','KA04IJ7890',5,5,NULL,1,NULL,NULL),(6,'2026-03-15 14:00:00.000000','SRV0006','2026-03-10 10:00:00.000000',NULL,'REPAIR','SCHEDULED','2026-03-26 21:29:01.050855','KA01KL1212',5,6,NULL,1,NULL,NULL),(7,'2025-09-22 15:30:00.000000','SRV0007','2025-09-18 10:00:00.000000',NULL,'PERIODIC','COMPLETED','2026-03-26 21:29:01.050874','KA03MN3434',5,7,NULL,1,NULL,NULL),(8,'2026-01-20 09:00:00.000000','SRV0008','2026-01-15 10:00:00.000000',NULL,'REPAIR','COMPLETED','2026-03-26 21:29:01.050899','KA05OP5656',5,10,NULL,1,NULL,NULL),(9,'2025-10-05 10:00:00.000000','SRV0009','2025-10-01 10:00:00.000000',NULL,'PERIODIC','COMPLETED','2026-03-26 21:29:01.050921','KA01AB1111',5,16,NULL,1,NULL,NULL),(10,'2025-11-10 14:00:00.000000','SRV0010','2025-11-05 10:00:00.000000',NULL,'REPAIR','IN_PROGRESS','2026-03-26 21:29:01.050942','KA03CD2222',5,17,NULL,1,NULL,NULL),(11,'2025-12-15 09:30:00.000000','SRV0011','2025-12-10 10:00:00.000000',NULL,'ACCIDENTAL','COMPLETED','2026-03-26 21:29:01.050966','KA05EF3333',5,18,NULL,1,NULL,NULL),(12,'2026-01-20 11:00:00.000000','SRV0012','2026-01-15 10:00:00.000000',NULL,'WARRANTY','COMPLETED','2026-03-26 21:29:01.050986','KA02GH4444',5,19,NULL,1,NULL,NULL),(13,'2026-02-05 10:30:00.000000','SRV0013','2026-02-01 10:00:00.000000',NULL,'PERIODIC','SCHEDULED','2026-03-26 21:29:01.051005','KA04IJ5555',5,20,NULL,1,NULL,NULL),(14,'2026-03-25 14:00:00.000000','SRV0014','2026-03-20 10:00:00.000000',NULL,'REPAIR','SCHEDULED','2026-03-26 21:29:01.051023','KA01KL6666',5,21,NULL,1,NULL,NULL),(15,'2025-09-12 15:30:00.000000','SRV0015','2025-09-08 10:00:00.000000',NULL,'PERIODIC','COMPLETED','2026-03-26 21:29:01.051042','KA03MN7777',5,22,NULL,1,NULL,NULL),(16,'2026-01-30 09:00:00.000000','SRV0016','2026-01-25 10:00:00.000000',NULL,'REPAIR','COMPLETED','2026-03-26 21:29:01.051193','KA05OP8888',5,23,NULL,1,NULL,NULL),(17,'2026-03-14 10:00:00.000000','SRV0017','2026-03-11 10:00:00.000000',NULL,'PERIODIC','SCHEDULED','2026-03-26 21:29:01.051223','KA01AB1234',5,1,NULL,1,NULL,NULL),(18,'2026-03-14 14:00:00.000000','SRV0018','2026-03-12 11:30:00.000000',NULL,'REPAIR','IN_PROGRESS','2026-03-26 21:29:01.051234','KA03CD5678',5,2,NULL,1,NULL,NULL),(19,'2026-03-15 09:30:00.000000','SRV0019','2026-03-13 14:15:00.000000',NULL,'ACCIDENTAL','SCHEDULED','2026-03-26 21:29:01.051244','KA05EF9012',5,3,NULL,1,NULL,NULL),(20,'2026-03-16 11:00:00.000000','SRV0020','2026-03-14 09:45:00.000000',NULL,'WARRANTY','SCHEDULED','2026-03-26 21:29:01.051254','KA02GH3456',5,4,NULL,1,NULL,NULL),(21,'2026-03-26 10:00:00.000000','SRV0021',NULL,'First free service','PERIODIC','SCHEDULED','2026-03-26 21:29:01.051264','KA01AB1111',5,1,1,1,NULL,NULL),(22,'2026-03-26 11:30:00.000000','SRV0022',NULL,'Brake squeaking sound','REPAIR','IN_PROGRESS','2026-03-26 21:29:01.051274','KA02BC2222',5,2,2,1,NULL,NULL),(23,'2026-03-26 14:00:00.000000','SRV0023',NULL,'Clutch hardness issue','WARRANTY','SCHEDULED','2026-03-26 21:29:01.051284','KA03CD3333',5,3,3,1,NULL,NULL),(24,'2026-03-27 09:30:00.000000','SRV0024',NULL,'Rear bumper replacement','ACCIDENTAL','SCHEDULED','2026-03-26 21:29:01.051295','KA04DE4444',5,4,4,1,NULL,NULL),(25,'2026-03-27 10:00:00.000000','SRV0025',NULL,'Pre-trip inspection','PERIODIC','SCHEDULED','2026-03-26 21:29:01.051305','KA05EF5555',5,5,5,1,NULL,NULL),(26,'2026-03-28 15:00:00.000000','SRV0026',NULL,'Oil change done','PERIODIC','COMPLETED','2026-03-26 21:29:01.051314','KA01AB1111',5,1,1,1,NULL,NULL),(27,'2026-03-28 16:00:00.000000','SRV0027',NULL,'Customer not reachable','REPAIR','CANCELLED','2026-03-26 21:29:01.051324','KA02BC2222',5,2,2,1,NULL,NULL),(28,'2026-03-29 11:00:00.000000','SRV0028',NULL,'Annual service','PERIODIC','SCHEDULED','2026-03-26 21:29:01.051334','KA03CD3333',5,3,3,1,NULL,NULL),(29,'2026-03-29 12:30:00.000000','SRV0029',NULL,'AC not cooling','WARRANTY','IN_PROGRESS','2026-03-26 21:29:01.051344','KA04DE4444',5,4,4,1,NULL,NULL),(30,'2026-03-30 14:00:00.000000','SRV0030',NULL,'Tyre rotation and alignment','PERIODIC','IN_PROGRESS','2026-03-26 21:29:01.051354','KA05EF5555',5,5,5,1,NULL,NULL),(31,'2026-03-26 13:00:00.000000','REQ-661006','2026-03-26 07:17:41.091865','','REPAIR','SCHEDULED','2026-03-26 21:29:01.051365','TH-49-4950',5,5,NULL,1,NULL,NULL),(32,'2026-04-20 17:00:00.000000','REQ-088814','2026-03-26 22:58:08.884526','','PERIODIC','SCHEDULED','2026-03-26 22:58:08.884528','TN-04-20206',12,50,NULL,6,NULL,NULL),(33,'2026-03-31 10:00:00.000000','SRV-00124','2026-03-30 21:45:48.000000','Regular 10,000 km Maintenance Service. Oil change and minor checks.','PERIODIC','SCHEDULED','2026-03-30 21:45:48.000000','TN-01-AB-1234',6,1,1,1,NULL,NULL),(34,'2026-03-30 11:30:00.000000','SRV-00125','2026-03-30 21:45:48.000000','Brake pad replacement and alignment.','REPAIR','IN_PROGRESS','2026-03-30 21:45:48.000000','TN-22-CX-9988',7,2,2,1,NULL,NULL),(35,'2026-03-30 09:15:00.000000','SRV-00126','2026-03-30 21:45:48.000000','A/C not blowing cold air. Full diagnostic required.','REPAIR','IN_PROGRESS','2026-03-30 21:45:48.000000','TN-05-XY-5544',6,3,12,1,NULL,NULL),(36,'2026-04-02 14:00:00.000000','SRV-00127','2026-03-30 21:45:48.000000','Full body wash, interior detailing, and polishing.','PERIODIC','SCHEDULED','2026-03-30 21:45:48.000000','TN-10-MM-3322',7,4,1,1,NULL,NULL),(37,'2026-03-30 15:45:00.000000','SRV-00128','2026-03-30 21:45:48.000000','Engine knocking sound. Needs immediate inspection.','REPAIR','IN_PROGRESS','2026-03-30 21:45:48.000000','TN-11-PL-8877',6,5,2,1,NULL,NULL),(38,'2026-03-15 10:00:00.000000','SRV-00101','2026-03-12 10:00:00.000000','Scheduled Maintenance','PERIODIC','COMPLETED','2026-03-15 16:00:00.000000','TN-01-ZZ-1111',6,1,1,1,NULL,NULL),(39,'2026-03-20 12:00:00.000000','SRV-00110','2026-03-18 09:00:00.000000','Tire Replacement','REPAIR','COMPLETED','2026-03-20 15:00:00.000000','TN-02-ZZ-2222',7,2,2,1,NULL,NULL),(40,'2026-03-25 09:00:00.000000','SRV-00115','2026-03-22 14:00:00.000000','Battery Issue','WARRANTY','COMPLETED','2026-03-25 11:30:00.000000','TN-03-ZZ-3333',6,3,12,1,NULL,NULL),(41,'2026-04-01 10:00:00.000000','SA-2026-001','2026-04-01 09:00:00.000000',NULL,'PERIODIC','COMPLETED',NULL,'TN-01-AB-1234',5,61,NULL,1,NULL,NULL),(42,'2026-04-01 11:30:00.000000','SA-2026-002','2026-04-01 11:00:00.000000',NULL,'REPAIR','IN_PROGRESS',NULL,'TN-07-CD-5678',5,63,NULL,1,NULL,NULL),(43,'2026-04-02 14:00:00.000000','SA-2026-003','2026-04-02 10:00:00.000000',NULL,'WARRANTY','SCHEDULED',NULL,'TN-05-XY-9012',5,2,NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `service_appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spare_part_inventory`
--

DROP TABLE IF EXISTS `spare_part_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spare_part_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `part_id` bigint NOT NULL,
  `location_id` bigint NOT NULL,
  `quantity` decimal(10,3) NOT NULL DEFAULT '0.000',
  `reorder_level` decimal(10,3) DEFAULT '5.000',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `part_id` (`part_id`),
  KEY `fk_spi_location` (`location_id`),
  CONSTRAINT `fk_spi_location` FOREIGN KEY (`location_id`) REFERENCES `inventory_locations` (`id`),
  CONSTRAINT `fk_spi_part` FOREIGN KEY (`part_id`) REFERENCES `spare_parts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spare_part_inventory`
--

LOCK TABLES `spare_part_inventory` WRITE;
/*!40000 ALTER TABLE `spare_part_inventory` DISABLE KEYS */;
INSERT INTO `spare_part_inventory` VALUES (1,1,3,50.000,10.000,'2026-03-25 16:52:57'),(2,2,3,20.000,5.000,'2026-03-25 16:52:57'),(3,3,3,30.000,10.000,'2026-03-25 16:52:57'),(4,4,3,40.000,15.000,'2026-03-25 16:52:57'),(5,5,3,15.000,5.000,'2026-03-25 16:52:57');
/*!40000 ALTER TABLE `spare_part_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spare_parts`
--

DROP TABLE IF EXISTS `spare_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spare_parts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(80) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `description` text,
  `gst_rate` decimal(5,2) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `part_number` varchar(50) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `supplier_id` bigint DEFAULT NULL,
  `dealer_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_se9rxewv9r3wcqefv7jvbp19w` (`part_number`),
  KEY `IDXf2k5732mv0wtohhr1y10x7uwc` (`category`),
  KEY `IDXaf4ppm0vfa0w5hosn4b5n1krk` (`supplier_id`),
  KEY `IDXs0sx616dxcin01cafynl9oe8k` (`dealer_id`),
  CONSTRAINT `FK9456yuqmeyj2oybmq52q0pcx7` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `FK9mi2kwbhi0a1p2y3picrwkgwk` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spare_parts`
--

LOCK TABLES `spare_parts` WRITE;
/*!40000 ALTER TABLE `spare_parts` DISABLE KEYS */;
INSERT INTO `spare_parts` VALUES (1,'Engine',NULL,'Genuine oil filter for all models',18.00,NULL,'Oil Filter','P-OIL-FLT-01','Piece',450.00,1,1),(2,'Brakes',NULL,'High performance ceramic brake pads',18.00,NULL,'Brake Pads (Front)','P-BRK-PAD-02','Set',2000.00,1,1),(3,'Consumables',NULL,'Long-life radiator coolant 1L',18.00,NULL,'Coolant','P-CLNT-03','Bottle',320.00,2,1),(4,'Engine',NULL,'Iridium spark plug for better ignition',18.00,NULL,'Spark Plug','P-SPK-PLG-04','Piece',580.00,1,1),(5,'Accessories',NULL,'Premium silicon wiper blades (Set of 2)',18.00,NULL,'Wiper Blades','P-WPR-05','Set',950.00,2,1);
/*!40000 ALTER TABLE `spare_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `gst_number` varchar(20) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_eegixpn11chp14nb25tl3ucv0` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Chennai, TN','Amit Shah',NULL,'amit@hyundaispares.com','33AAACH1234F1Z1','Genuine Hyundai Spares','9876543210'),(2,'Bangalore, KA','Kiran Rao',NULL,'kiran@metroauto.in','29BBBCH5678G1Z2','Metro Auto Parts','9988776655');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_models`
--

DROP TABLE IF EXISTS `vehicle_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_models` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `launch_year` int DEFAULT NULL,
  `model_code` varchar(20) NOT NULL,
  `model_name` varchar(100) NOT NULL,
  `segment` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_lbytf0i6qlsqaky0hmw16y90k` (`model_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_models`
--

LOCK TABLES `vehicle_models` WRITE;
/*!40000 ALTER TABLE `vehicle_models` DISABLE KEYS */;
INSERT INTO `vehicle_models` VALUES (1,NULL,NULL,2020,'CRETA','Creta','SUV'),(2,NULL,NULL,2019,'VENUE','Venue','Compact SUV'),(3,NULL,NULL,2023,'VERNA','Verna','Sedan'),(4,NULL,NULL,2020,'I20','i20','Premium Hatchback'),(5,NULL,NULL,2022,'TUCSON','Tucson','Premium SUV'),(6,NULL,NULL,2023,'IONIQ5','Ioniq 5','EV SUV'),(7,NULL,NULL,2023,'EXTER','Exter','Micro SUV'),(8,NULL,NULL,2020,'AURA','Aura','Compact Sedan');
/*!40000 ALTER TABLE `vehicle_models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_variants`
--

DROP TABLE IF EXISTS `vehicle_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_variants` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `ex_showroom_price` decimal(12,2) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `seating_capacity` int DEFAULT NULL,
  `transmission` varchar(30) DEFAULT NULL,
  `variant_code` varchar(20) NOT NULL,
  `variant_name` varchar(100) NOT NULL,
  `engine_type_id` bigint NOT NULL,
  `model_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_9unogqhw9dc8ecrgtbkq6xkkm` (`variant_code`),
  KEY `IDX1keaynl7mfccmk1i8fcah36yk` (`model_id`),
  KEY `FKfkbpfmpasvm3htncymdlqmbcn` (`engine_type_id`),
  CONSTRAINT `FKfkbpfmpasvm3htncymdlqmbcn` FOREIGN KEY (`engine_type_id`) REFERENCES `engine_types` (`id`),
  CONSTRAINT `FKyc4sx2ug6s7fxlcohwnm5hja` FOREIGN KEY (`model_id`) REFERENCES `vehicle_models` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_variants`
--

LOCK TABLES `vehicle_variants` WRITE;
/*!40000 ALTER TABLE `vehicle_variants` DISABLE KEYS */;
INSERT INTO `vehicle_variants` VALUES (1,NULL,1087000.00,NULL,NULL,'Manual','CRT-E','E 1.5 Petrol MT',2,1),(2,NULL,1900000.00,NULL,NULL,'Automatic','CRT-SX','SX 1.5 Diesel AT',3,1),(3,NULL,894000.00,NULL,NULL,'Manual','VEN-S','S 1.2 Petrol MT',1,2),(4,NULL,1318000.00,NULL,NULL,'DCT','VEN-SX','SX (O) 1.0 Turbo DCT',4,2),(5,NULL,1423000.00,NULL,NULL,'CVT','VRN-SX','SX 1.5 Petrol CVT',2,3),(6,NULL,1116000.00,NULL,NULL,'IVT','I20-ASTA','Asta (O) 1.2 Petrol IVT',1,4),(7,NULL,3546000.00,NULL,NULL,'Automatic','TUC-SIG','Signature 2.0 Diesel AT',3,5),(8,NULL,4495000.00,NULL,NULL,'Automatic','ION-RWD','RWD 72.6 kWh',5,6),(9,NULL,738000.00,NULL,NULL,'Manual','EXT-S','S 1.2 Kappa MT',1,7),(10,NULL,896000.00,NULL,NULL,'AMT','EXT-SX','SX 1.2 AMT',1,7),(11,NULL,722000.00,NULL,NULL,'Manual','AUR-S','S 1.2 Petrol MT',1,8),(12,NULL,2000000.00,NULL,NULL,'DCT','CRT-SXO','SX (O) 1.5 Turbo DCT',4,1);
/*!40000 ALTER TABLE `vehicle_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `arrival_date` date DEFAULT NULL,
  `chassis_number` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `dealer_cost` decimal(12,2) DEFAULT NULL,
  `engine_number` varchar(255) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `mfg_date` date DEFAULT NULL,
  `mfg_year` int DEFAULT NULL,
  `status` enum('IN_STOCK','ALLOCATED','SOLD','IN_TRANSIT','DEMO') DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `vin` varchar(17) NOT NULL,
  `color_id` bigint NOT NULL,
  `location_id` bigint NOT NULL,
  `variant_id` bigint NOT NULL,
  `dealer_id` bigint DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_6brka0b8j7n06xd43x37hlvlt` (`vin`),
  UNIQUE KEY `UK_nxje1115h6kn6pauv8vwttj0t` (`chassis_number`),
  UNIQUE KEY `UK_3jtis68l3n7tt31ob3apate19` (`engine_number`),
  KEY `IDXsu9n2a5safs6cygapxku2g0qk` (`status`),
  KEY `IDXavfwhji0uwjjf9qua8x3fdqyf` (`variant_id`),
  KEY `IDXj46hc0bmb9swg71slwaj9579` (`location_id`),
  KEY `FK1javby4k3n2dthnb0mc2vdl01` (`color_id`),
  KEY `fk_vehicles_dealer` (`dealer_id`),
  CONSTRAINT `FK1javby4k3n2dthnb0mc2vdl01` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`),
  CONSTRAINT `fk_vehicles_dealer` FOREIGN KEY (`dealer_id`) REFERENCES `dealers` (`id`),
  CONSTRAINT `FKnwedi6b5p6shgfvd4lv0tjsyq` FOREIGN KEY (`location_id`) REFERENCES `inventory_locations` (`id`),
  CONSTRAINT `FKslkpu1kuh749lmosmetvqi120` FOREIGN KEY (`variant_id`) REFERENCES `vehicle_variants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,'2025-08-25','CHA0001','2025-09-05 10:00:00.000000',1000000.00,'ENG0001',NULL,'2025-08-15',2025,'ALLOCATED','2026-03-27 22:33:48.762973','VIN0000000010001',1,1,1,1,NULL,NULL),(2,'2025-10-20','CHA0002','2025-11-01 10:00:00.000000',1050000.00,'ENG0002',NULL,'2025-10-10',2025,'ALLOCATED',NULL,'VIN0000000010002',2,1,6,1,NULL,NULL),(3,'2025-11-15','CHA0003','2025-12-01 10:00:00.000000',1750000.00,'ENG0003',NULL,'2025-11-05',2025,'ALLOCATED','2026-03-26 22:57:20.558055','VIN0000000010003',4,2,2,1,NULL,NULL),(4,'2025-12-20','CHA0004','2026-01-05 10:00:00.000000',1200000.00,'ENG0004',NULL,'2025-12-10',2025,'ALLOCATED','2026-03-25 22:05:18.164370','VIN0000000010004',5,2,4,1,NULL,NULL),(5,'2026-01-25','CHA0005','2026-02-10 10:00:00.000000',4100000.00,'ENG0005',NULL,'2026-01-15',2026,'IN_STOCK',NULL,'VIN0000000010005',1,1,8,1,NULL,NULL),(6,'2025-09-30','CHA0006','2025-10-15 10:00:00.000000',1850000.00,'ENG0006',NULL,'2025-09-20',2025,'SOLD',NULL,'VIN0000000010006',7,1,12,1,NULL,NULL),(7,'2025-11-25','CHA0007','2025-12-10 10:00:00.000000',3250000.00,'ENG0007',NULL,'2025-11-15',2025,'SOLD',NULL,'VIN0000000010007',5,2,7,1,NULL,NULL),(8,'2026-01-10','CHA0008','2026-01-20 10:00:00.000000',680000.00,'ENG0008',NULL,'2026-01-01',2026,'ALLOCATED','2026-03-25 22:06:43.263239','VIN0000000010008',8,1,9,1,NULL,NULL),(9,'2026-02-10','CHA0009','2026-02-15 10:00:00.000000',820000.00,'ENG0009',NULL,'2026-02-01',2026,'IN_STOCK',NULL,'VIN0000000010009',9,2,10,1,NULL,NULL),(10,'2026-02-25','CHA0010','2026-03-01 10:00:00.000000',800000.00,'ENG0010',NULL,'2026-02-15',2026,'IN_STOCK',NULL,'VIN0000000010010',1,1,3,1,NULL,NULL),(11,'2025-08-30','CHA0011','2025-09-15 10:00:00.000000',1000000.00,'ENG0011',NULL,'2025-08-20',2025,'SOLD',NULL,'VIN0000000010011',2,1,1,1,NULL,NULL),(12,'2025-09-05','CHA0012','2025-09-20 10:00:00.000000',1750000.00,'ENG0012',NULL,'2025-08-25',2025,'SOLD',NULL,'VIN0000000010012',1,1,2,1,NULL,NULL),(13,'2025-09-30','CHA0013','2025-10-15 10:00:00.000000',3250000.00,'ENG0013',NULL,'2025-09-20',2025,'SOLD',NULL,'VIN0000000010013',7,2,7,1,NULL,NULL),(14,'2025-10-15','CHA0014','2025-10-25 10:00:00.000000',1000000.00,'ENG0014',NULL,'2025-10-10',2025,'ALLOCATED',NULL,'VIN0000000010014',5,2,1,1,NULL,NULL),(15,'2025-10-25','CHA0015','2025-11-10 10:00:00.000000',1750000.00,'ENG0015',NULL,'2025-10-15',2025,'SOLD',NULL,'VIN0000000010015',8,1,2,1,NULL,NULL),(16,'2025-11-20','CHA0016','2025-12-05 10:00:00.000000',3250000.00,'ENG0016',NULL,'2025-11-10',2025,'SOLD',NULL,'VIN0000000010016',1,1,7,1,NULL,NULL),(17,'2025-11-30','CHA0017','2025-12-20 10:00:00.000000',800000.00,'ENG0017',NULL,'2025-11-25',2025,'ALLOCATED',NULL,'VIN0000000010017',2,2,3,1,NULL,NULL),(18,'2025-12-30','CHA0018','2026-01-15 10:00:00.000000',4100000.00,'ENG0018',NULL,'2025-12-20',2026,'SOLD',NULL,'VIN0000000010018',7,1,8,1,NULL,NULL),(19,'2026-01-15','CHA0019','2026-01-25 10:00:00.000000',1300000.00,'ENG0019',NULL,'2026-01-05',2026,'SOLD',NULL,'VIN0000000010019',5,2,5,1,NULL,NULL),(20,'2026-01-25','CHA0020','2026-02-10 10:00:00.000000',800000.00,'ENG0020',NULL,'2026-01-15',2026,'ALLOCATED',NULL,'VIN0000000010020',8,1,3,1,NULL,NULL),(21,'2026-02-10','CHA0021','2026-03-01 10:00:00.000000',1850000.00,'ENG0021',NULL,'2026-02-01',2026,'IN_STOCK',NULL,'VIN0000000010021',1,1,12,1,NULL,NULL),(22,'2026-02-20','CHA0022','2026-03-05 10:00:00.000000',680000.00,'ENG0022',NULL,'2026-02-10',2026,'IN_STOCK',NULL,'VIN0000000010022',2,1,9,1,NULL,NULL),(23,'2026-03-01','CHA0023','2026-03-10 10:00:00.000000',820000.00,'ENG0023',NULL,'2026-02-20',2026,'IN_STOCK',NULL,'VIN0000000010023',4,2,10,1,NULL,NULL),(24,'2026-03-10','CHA0024','2026-03-15 10:00:00.000000',1750000.00,'ENG0024',NULL,'2026-03-01',2026,'IN_STOCK',NULL,'VIN0000000010024',5,2,2,1,NULL,NULL),(25,'2026-03-15','CHA0025','2026-03-20 10:00:00.000000',1200000.00,'ENG0025',NULL,'2026-03-05',2026,'IN_STOCK',NULL,'VIN0000000010025',1,1,4,1,NULL,NULL),(26,'2026-03-20','CHA0026','2026-03-25 10:00:00.000000',4100000.00,'ENG0026',NULL,'2026-03-10',2026,'IN_STOCK',NULL,'VIN0000000010026',2,1,8,1,NULL,NULL),(27,'2026-03-25','CHA0027','2026-03-30 10:00:00.000000',1300000.00,'ENG0027',NULL,'2026-03-15',2026,'IN_STOCK',NULL,'VIN0000000010027',5,2,5,1,NULL,NULL),(28,'2026-03-30','CHA0028','2026-04-01 10:00:00.000000',1000000.00,'ENG0028',NULL,'2026-03-20',2026,'IN_STOCK',NULL,'VIN0000000010028',8,1,1,1,NULL,NULL),(29,'2026-04-01','CHA0029','2026-04-05 10:00:00.000000',3250000.00,'ENG0029',NULL,'2026-03-25',2026,'IN_STOCK',NULL,'VIN0000000010029',9,2,7,1,NULL,NULL),(30,'2026-04-08','CHA0030','2026-04-10 10:00:00.000000',800000.00,'ENG0030',NULL,'2026-03-30',2026,'IN_STOCK',NULL,'VIN0000000010030',1,1,3,1,NULL,NULL),(31,'2025-11-15','CHA2031','2025-11-20 09:00:00.000000',923950.00,'ENG1031','2025-11-20','2025-11-01',2026,'IN_STOCK',NULL,'VIN1A2B3C4D5E6F7',1,1,1,1,NULL,NULL),(32,'2025-09-01','CHA2032','2025-09-15 10:15:00.000000',1615000.00,'ENG1032','2025-09-15','2025-08-15',2025,'ALLOCATED',NULL,'VIN2A3B4C5D6E7F8',2,2,2,1,NULL,NULL),(33,'2026-01-05','CHA2033','2026-01-10 11:30:00.000000',759900.00,'ENG1033','2026-01-10','2025-12-20',2026,'IN_STOCK',NULL,'VIN3A4B5C6D7E8F9',3,3,3,1,NULL,NULL),(34,'2025-09-25','CHA2034','2025-10-05 14:00:00.000000',1120300.00,'ENG1034','2025-10-05','2025-09-10',2025,'SOLD',NULL,'VIN4A5B6C7D8E9F0',4,1,4,1,NULL,NULL),(35,'2026-02-10','CHA2035','2026-02-18 09:45:00.000000',1209550.00,'ENG1035','2026-02-18','2026-01-20',2026,'IN_STOCK',NULL,'VIN5A6B7C8D9E0F1',5,2,5,1,NULL,NULL),(36,'2025-08-15','CHA2036','2025-08-22 16:20:00.000000',948600.00,'ENG1036','2025-08-22','2025-08-01',2025,'DEMO',NULL,'VIN6A7B8C9D0E1F2',6,3,6,1,NULL,NULL),(37,'2026-02-25','CHA2037','2026-03-01 10:00:00.000000',3014100.00,'ENG1037','2026-03-01','2026-02-10',2026,'IN_STOCK',NULL,'VIN7A8B9C0D1E2F3',7,1,7,1,NULL,NULL),(38,'2026-03-01','CHA2038','2026-03-05 11:15:00.000000',3820750.00,'ENG1038','2026-03-05','2026-02-15',2026,'IN_STOCK',NULL,'VIN8A9B0C1D2E3F4',8,2,8,1,NULL,NULL),(39,'2025-11-01','CHA2039','2025-11-12 15:30:00.000000',627300.00,'ENG1039','2025-11-12','2025-10-15',2025,'SOLD',NULL,'VIN9A0B1C2D3E4F5',9,3,9,1,NULL,NULL),(40,'2026-02-15','CHA2040','2026-02-28 09:10:00.000000',761600.00,'ENG1040','2026-02-28','2026-01-25',2026,'IN_STOCK',NULL,'VIN0A1B2C3D4E5F6',1,1,10,1,NULL,NULL),(41,'2025-11-25','CHA2041','2025-12-05 10:40:00.000000',613700.00,'ENG1041','2025-12-05','2025-11-10',2025,'ALLOCATED',NULL,'VIN1B2C3D4E5F6G7',2,2,11,1,NULL,NULL),(42,'2026-01-10','CHA2042','2026-01-20 12:00:00.000000',1700000.00,'ENG1042','2026-01-20','2025-12-25',2026,'IN_STOCK',NULL,'VIN2B3C4D5E6F7G8',3,3,12,1,NULL,NULL),(43,'2025-09-10','CHA2043','2025-09-30 14:15:00.000000',923950.00,'ENG1043','2025-09-30','2025-08-20',2025,'SOLD',NULL,'VIN3B4C5D6E7F8G9',4,1,1,1,NULL,NULL),(44,'2026-01-25','CHA2044','2026-02-10 16:30:00.000000',1615000.00,'ENG1044','2026-02-10','2026-01-05',2026,'IN_STOCK',NULL,'VIN4B5C6D7E8F9G0',5,2,2,1,NULL,NULL),(45,'2025-08-05','CHA2045','2025-08-15 09:20:00.000000',759900.00,'ENG1045','2025-08-15','2025-07-20',2025,'DEMO',NULL,'VIN5B6C7D8E9F0G1',6,3,3,1,NULL,NULL),(46,'2026-03-01','CHA2046','2026-03-08 11:45:00.000000',1120300.00,'ENG1046','2026-03-08','2026-02-15',2026,'IN_STOCK',NULL,'VIN6B7C8D9E0F1G2',7,1,4,1,NULL,NULL),(47,'2025-10-15','CHA2047','2025-10-25 10:10:00.000000',1209550.00,'ENG1047','2025-10-25','2025-09-30',2025,'ALLOCATED',NULL,'VIN7B8C9D0E1F2G3',8,2,5,1,NULL,NULL),(48,'2026-01-05','CHA2048','2026-01-15 15:50:00.000000',948600.00,'ENG1048','2026-01-15','2025-12-20',2026,'IN_STOCK',NULL,'VIN8B9C0D1E2F3G4',9,3,6,1,NULL,NULL),(49,'2025-10-15','CHA2049','2025-11-05 13:25:00.000000',3014100.00,'ENG1049','2025-11-05','2025-09-25',2025,'SOLD',NULL,'VIN9B0C1D2E3F4G5',1,1,7,1,NULL,NULL),(50,'2026-02-15','CHA2050','2026-02-22 10:05:00.000000',3820750.00,'ENG1050','2026-02-22','2026-02-01',2026,'IN_STOCK',NULL,'VIN0B1C2D3E4F5G6',2,2,8,1,NULL,NULL),(51,'2025-09-10','CHA2051','2025-09-20 14:40:00.000000',627300.00,'ENG1051','2025-09-20','2025-08-25',2025,'ALLOCATED',NULL,'VIN1C2D3E4F5G6H7',3,3,9,1,NULL,NULL),(52,'2026-03-05','CHA2052','2026-03-12 11:30:00.000000',761600.00,'ENG1052','2026-03-12','2026-02-20',2026,'IN_STOCK',NULL,'VIN2C3D4E5F6G7H8',4,1,10,1,NULL,NULL),(53,'2025-08-20','CHA2053','2025-08-30 09:15:00.000000',613700.00,'ENG1053','2025-08-30','2025-08-05',2025,'SOLD',NULL,'VIN3C4D5E6F7G8H9',5,2,11,1,NULL,NULL),(54,'2025-12-25','CHA2054','2026-01-05 16:10:00.000000',1700000.00,'ENG1054','2026-01-05','2025-12-10',2026,'IN_STOCK',NULL,'VIN4C5D6E7F8G9H0',6,3,12,1,NULL,NULL),(55,'2025-07-15','CHA2055','2025-07-28 10:50:00.000000',923950.00,'ENG1055','2025-07-28','2025-07-01',2025,'DEMO',NULL,'VIN5C6D7E8F9G0H1',7,1,1,1,NULL,NULL),(56,'2026-02-05','CHA2056','2026-02-14 14:20:00.000000',1615000.00,'ENG1056','2026-02-14','2026-01-25',2026,'IN_STOCK',NULL,'VIN6C7D8E9F0G1H2',8,2,2,1,NULL,NULL),(57,'2025-10-10','CHA2057','2025-10-18 11:05:00.000000',759900.00,'ENG1057','2025-10-18','2025-09-25',2025,'ALLOCATED',NULL,'VIN7C8D9E0F1G2H3',9,3,3,1,NULL,NULL),(58,'2025-11-15','CHA2058','2025-11-25 15:45:00.000000',1120300.00,'ENG1058','2025-11-25','2025-11-01',2025,'SOLD',NULL,'VIN8C9D0E1F2G3H4',1,1,4,1,NULL,NULL),(59,'2026-03-01','CHA2059','2026-03-10 09:30:00.000000',1209550.00,'ENG1059','2026-03-10','2026-02-15',2026,'IN_STOCK',NULL,'VIN9C0D1E2F3G4H5',2,2,5,1,NULL,NULL),(60,'2025-12-05','CHA2060','2025-12-12 13:15:00.000000',948600.00,'ENG1060','2025-12-12','2025-11-20',2025,'ALLOCATED',NULL,'VIN0C1D2E3F4G5H6',3,3,6,1,NULL,NULL),(61,'2026-01-22','CHA2061','2026-01-28 10:40:00.000000',3014100.00,'ENG1061','2026-01-28','2026-01-10',2026,'IN_STOCK',NULL,'VIN1D2E3F4G5H6I7',4,1,7,1,NULL,NULL),(62,'2025-07-30','CHA2062','2025-08-05 14:50:00.000000',3820750.00,'ENG1062','2025-08-05','2025-07-15',2025,'SOLD',NULL,'VIN2D3E4F5G6H7I8',5,2,8,1,NULL,NULL),(63,'2026-02-01','CHA2063','2026-02-08 11:20:00.000000',627300.00,'ENG1063','2026-02-08','2026-01-20',2026,'IN_STOCK',NULL,'VIN3D4E5F6G7H8I9',6,3,9,1,NULL,NULL),(64,'2025-10-20','CHA2064','2025-10-30 09:00:00.000000',761600.00,'ENG1064','2025-10-30','2025-09-30',2025,'ALLOCATED',NULL,'VIN4D5E6F7G8H9I0',7,1,10,1,NULL,NULL),(65,'2026-02-25','CHA2065','2026-03-02 16:30:00.000000',613700.00,'ENG1065','2026-03-02','2026-02-10',2026,'IN_STOCK',NULL,'VIN5D6E7F8G9H0I1',8,2,11,1,NULL,NULL),(66,'2025-09-10','CHA2066','2025-09-18 10:15:00.000000',1700000.00,'ENG1066','2025-09-18','2025-08-30',2025,'SOLD',NULL,'VIN6D7E8F9G0H1I2',9,3,12,1,NULL,NULL),(67,'2026-01-01','CHA2067','2026-01-12 14:00:00.000000',923950.00,'ENG1067','2026-01-12','2025-12-15',2026,'IN_STOCK',NULL,'VIN7D8E9F0G1H2I3',1,1,1,1,NULL,NULL),(68,'2025-10-30','CHA2068','2025-11-08 11:45:00.000000',1615000.00,'ENG1068','2025-11-08','2025-10-15',2025,'DEMO',NULL,'VIN8D9E0F1G2H3I4',2,2,2,1,NULL,NULL),(69,'2026-02-18','CHA2069','2026-02-25 09:20:00.000000',759900.00,'ENG1069','2026-02-25','2026-02-05',2026,'IN_STOCK',NULL,'VIN9D0E1F2G3H4I5',3,3,3,1,NULL,NULL),(70,'2025-12-15','CHA2070','2025-12-20 15:10:00.000000',1120300.00,'ENG1070','2025-12-20','2025-11-30',2025,'SOLD',NULL,'VIN0E1F2G3H4I5J6',4,1,4,1,NULL,NULL),(71,'2026-03-10','CHA2071','2026-03-14 10:30:00.000000',1209550.00,'ENG1071','2026-03-14','2026-02-25',2026,'IN_STOCK',NULL,'VIN1F2G3H4I5J6K7',5,2,5,1,NULL,NULL),(72,'2025-09-18','CHA2072','2025-09-25 13:40:00.000000',948600.00,'ENG1072','2025-09-25','2025-09-05',2025,'ALLOCATED',NULL,'VIN2F3G4H5I6J7K8',6,3,6,1,NULL,NULL),(73,'2026-01-18','CHA2073','2026-01-22 09:50:00.000000',3014100.00,'ENG1073','2026-01-22','2026-01-05',2026,'IN_STOCK',NULL,'VIN3F4G5H6I7J8K9',7,1,7,1,NULL,NULL),(74,'2025-09-30','CHA2074','2025-10-12 16:00:00.000000',3820750.00,'ENG1074','2025-10-12','2025-09-15',2025,'SOLD',NULL,'VIN4F5G6H7I8J9K0',8,2,8,1,NULL,NULL),(75,'2026-01-30','CHA2075','2026-02-05 11:15:00.000000',627300.00,'ENG1075','2026-02-05','2026-01-15',2026,'IN_STOCK',NULL,'VIN5F6G7H8I9J0K1',9,3,9,1,NULL,NULL),(76,'2025-08-22','CHA2076','2025-08-28 14:30:00.000000',761600.00,'ENG1076','2025-08-28','2025-08-10',2025,'ALLOCATED',NULL,'VIN6F7G8H9I0J1K2',1,1,10,1,NULL,NULL),(77,'2026-03-05','CHA2077','2026-03-11 10:10:00.000000',613700.00,'ENG1077','2026-03-11','2026-02-20',2026,'IN_STOCK',NULL,'VIN7F8G9H0I1J2K3',2,2,11,1,NULL,NULL),(78,'2025-11-10','CHA2078','2025-11-22 15:50:00.000000',1700000.00,'ENG1078','2025-11-22','2025-10-25',2025,'SOLD',NULL,'VIN8F9G0H1I2J3K4',3,3,12,1,NULL,NULL),(79,'2026-01-10','CHA2079','2026-01-18 09:40:00.000000',923950.00,'ENG1079','2026-01-18','2025-12-25',2026,'IN_STOCK',NULL,'VIN9F0G1H2I3J4K5',4,1,1,1,NULL,NULL),(80,'2025-11-30','CHA2080','2025-12-08 12:20:00.000000',1615000.00,'ENG1080','2025-12-08','2025-11-15',2025,'ALLOCATED',NULL,'VIN0F1G2H3I4J5K6',5,2,2,1,NULL,NULL),(81,'2025-09-20','CD001',NULL,880000.00,'ED001',NULL,'2025-09-01',2025,'SOLD',NULL,'VBKG26D001',7,1,3,1,NULL,NULL),(82,'2025-09-20','CD002',NULL,770000.00,'ED002',NULL,'2025-09-01',2025,'SOLD',NULL,'VBKG26D002',9,1,6,1,NULL,NULL),(83,'2025-10-15','CD003',NULL,1120000.00,'ED003',NULL,'2025-10-01',2025,'SOLD',NULL,'VBKG26D003',5,1,9,1,NULL,NULL),(84,'2025-10-15','CD004',NULL,1090000.00,'ED004',NULL,'2025-10-01',2025,'SOLD',NULL,'VBKG26D004',4,1,10,1,NULL,NULL),(85,'2025-10-25','CD005',NULL,1350000.00,'ED005',NULL,'2025-10-10',2025,'SOLD',NULL,'VBKG26D005',1,1,11,1,NULL,NULL),(86,'2025-11-15','CD006',NULL,880000.00,'ED006',NULL,'2025-11-01',2025,'SOLD',NULL,'VBKG26D006',9,1,3,1,NULL,NULL),(87,'2025-11-15','CD007',NULL,770000.00,'ED007',NULL,'2025-11-01',2025,'SOLD',NULL,'VBKG26D007',7,1,6,1,NULL,NULL),(88,'2025-11-25','CD008',NULL,1120000.00,'ED008',NULL,'2025-11-10',2025,'SOLD',NULL,'VBKG26D008',4,1,9,1,NULL,NULL),(89,'2025-12-15','CD009',NULL,1090000.00,'ED009',NULL,'2025-12-01',2025,'SOLD',NULL,'VBKG26D009',1,1,10,1,NULL,NULL),(90,'2025-12-15','CD010',NULL,1350000.00,'ED010',NULL,'2025-12-01',2025,'SOLD',NULL,'VBKG26D010',5,1,11,1,NULL,NULL),(91,'2026-01-05','CD011',NULL,880000.00,'ED011',NULL,'2025-12-10',2025,'SOLD',NULL,'VBKG26D011',4,1,3,1,NULL,NULL),(92,'2026-01-20','CD012',NULL,770000.00,'ED012',NULL,'2026-01-01',2026,'SOLD',NULL,'VBKG26D012',1,1,6,1,NULL,NULL),(93,'2026-01-20','CD013',NULL,1120000.00,'ED013',NULL,'2026-01-01',2026,'SOLD',NULL,'VBKG26D013',9,1,9,1,NULL,NULL),(94,'2026-02-01','CD014',NULL,1090000.00,'ED014',NULL,'2026-01-15',2026,'SOLD',NULL,'VBKG26D014',7,1,10,1,NULL,NULL),(95,'2026-02-01','CD015',NULL,1350000.00,'ED015',NULL,'2026-01-15',2026,'SOLD',NULL,'VBKG26D015',4,1,11,1,NULL,NULL),(96,'2026-02-05','CI001',NULL,880000.00,'EI001',NULL,'2026-01-20',2026,'SOLD',NULL,'VBKG26I001',5,1,3,1,NULL,NULL),(97,'2026-02-05','CI002',NULL,770000.00,'EI002',NULL,'2026-01-20',2026,'SOLD',NULL,'VBKG26I002',7,1,6,1,NULL,NULL),(98,'2026-02-15','CI003',NULL,1120000.00,'EI003',NULL,'2026-02-01',2026,'SOLD',NULL,'VBKG26I003',9,1,9,1,NULL,NULL),(99,'2026-02-15','CI004',NULL,1090000.00,'EI004',NULL,'2026-02-01',2026,'SOLD',NULL,'VBKG26I004',1,1,10,1,NULL,NULL),(100,'2026-02-20','CI005',NULL,1350000.00,'EI005',NULL,'2026-02-05',2026,'SOLD',NULL,'VBKG26I005',4,1,11,1,NULL,NULL),(101,'2026-02-20','CI006',NULL,880000.00,'EI006',NULL,'2026-02-05',2026,'SOLD',NULL,'VBKG26I006',9,1,3,1,NULL,NULL),(102,'2026-02-25','CI007',NULL,770000.00,'EI007',NULL,'2026-02-10',2026,'SOLD',NULL,'VBKG26I007',4,1,6,1,NULL,NULL),(103,'2026-02-25','CI008',NULL,1120000.00,'EI008',NULL,'2026-02-10',2026,'SOLD',NULL,'VBKG26I008',1,1,9,1,NULL,NULL),(104,'2026-03-01','CI009',NULL,1090000.00,'EI009',NULL,'2026-02-15',2026,'SOLD',NULL,'VBKG26I009',7,1,10,1,NULL,NULL),(105,'2026-03-01','CI010',NULL,1350000.00,'EI010',NULL,'2026-02-15',2026,'SOLD',NULL,'VBKG26I010',5,1,11,1,NULL,NULL),(108,'2026-03-15','CA003',NULL,1120000.00,'EA003',NULL,'2026-03-05',2026,'ALLOCATED',NULL,'VBKG26A003',5,1,9,1,NULL,NULL),(109,'2026-03-15','CA004',NULL,1090000.00,'EA004',NULL,'2026-03-05',2026,'ALLOCATED',NULL,'VBKG26A004',4,1,10,1,NULL,NULL),(110,'2026-03-18','CA005',NULL,1350000.00,'EA005',NULL,'2026-03-08',2026,'ALLOCATED',NULL,'VBKG26A005',1,1,11,1,NULL,NULL),(111,'2026-03-18','CA006',NULL,880000.00,'EA006',NULL,'2026-03-08',2026,'ALLOCATED',NULL,'VBKG26A006',9,1,3,1,NULL,NULL),(112,'2026-03-20','CA007',NULL,770000.00,'EA007',NULL,'2026-03-10',2026,'ALLOCATED',NULL,'VBKG26A007',4,1,6,1,NULL,NULL),(113,'2026-03-20','CA008',NULL,1120000.00,'EA008',NULL,'2026-03-10',2026,'ALLOCATED',NULL,'VBKG26A008',7,1,9,1,NULL,NULL),(114,'2026-03-22','CA009',NULL,1090000.00,'EA009',NULL,'2026-03-12',2026,'ALLOCATED',NULL,'VBKG26A009',9,1,10,1,NULL,NULL),(115,'2026-03-22','CA010',NULL,1350000.00,'EA010',NULL,'2026-03-12',2026,'ALLOCATED',NULL,'VBKG26A010',5,1,11,1,NULL,NULL);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'dealerconnect'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08  8:02:37
