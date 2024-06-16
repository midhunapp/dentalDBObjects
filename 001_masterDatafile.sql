USE [DHCM]

Insert into [User] (LoginName,PasswordHash,FirstName,LastName,UserType,IsActive)
values('admin',HASHBYTES('SHA2_512', 'admin'),'Admin','Admin','ADM',1)



INSERT INTO [Roles_Mf] (RoleName,RoleCode,IsActive) VALUES('Admin','ADM',1)
INSERT INTO [Roles_Mf] (RoleName,RoleCode,IsActive) VALUES('Doctor','DR',1)
INSERT INTO [Roles_Mf] (RoleName,RoleCode,IsActive) VALUES('Technician','THN',1)
INSERT INTO [Roles_Mf] (RoleName,RoleCode,IsActive) VALUES('Accounts','ACT',1)
INSERT INTO [Roles_Mf] (RoleName,RoleCode,IsActive) VALUES('Reception','REC',1)

INSERT INTO dbo.[User_Roles] (UserId,RoleId,ModifiedBy,ModifiedOn,IsActive) 
				VALUES(
				    (select Id from [User] where LoginName='admin'),
					(select Id from Roles_Mf where RoleName='Admin'),
					(select Id from Roles_Mf where RoleName='Admin'),
					CURRENT_TIMESTAMP,
					1)


insert into [Treatments_Mf] (TreatmentName,TreatmentCode,Amount,Currency,ModifiedBy,ModifiedOn)
values('Consultation','CONSULT',0,'AED',(select Id from [User] where LoginName='admin'),CURRENT_TIMESTAMP)
insert into [Treatments_Mf] (TreatmentName,TreatmentCode,Amount,Currency,ModifiedBy,ModifiedOn)
values('XRAY','XRAY',0,'AED',(select Id from [User] where LoginName='admin'),CURRENT_TIMESTAMP)

INSERT INTO [Nationality_Mf] (Id, NationalityCode,NationalityName, IsActive) VALUES

(1, 'AF', 'AFGHANISTAN', 1),

(2, 'AL', 'ALBANIA', 1),

(3, 'DZ', 'ALGERIA', 1),

(4, 'AS', 'AMERICAN SAMOA', 1),

(5, 'AD', 'ANDORRA', 1),

(6, 'AO', 'ANGOLA', 1),

(7, 'AI', 'ANGUILLA', 1),

(8, 'AQ', 'ANTARCTICA', 1),

(9, 'AG', 'ANTIGUA AND BARBUDA', 1),

(10, 'AR', 'ARGENTINA', 1),

(11, 'AM', 'ARMENIA', 1),

(12, 'AW', 'ARUBA', 1),

(13, 'AU', 'AUSTRALIA', 1),

(14, 'AT', 'AUSTRIA', 1),

(15, 'AZ', 'AZERBAIJAN', 1),

(16, 'BS', 'BAHAMAS', 1),

(17, 'BH', 'BAHRAIN', 1),

(18, 'BD', 'BANGLADESH', 1),

(19, 'BB', 'BARBADOS', 1),

(20, 'BY', 'BELARUS', 1),

(21, 'BE', 'BELGIUM', 1),

(22, 'BZ', 'BELIZE', 1),

(23, 'BJ', 'BENIN', 1),

(24, 'BM', 'BERMUDA', 1),

(25, 'BT', 'BHUTAN', 1),

(26, 'BO', 'BOLIVIA', 1),

(27, 'BA', 'BOSNIA AND HERZEGOVINA', 1),

(28, 'BW', 'BOTSWANA', 1),

(29, 'BV', 'BOUVET ISLAND', 1),

(30, 'BR', 'BRAZIL', 1),

(31, 'IO', 'BRITISH INDIAN OCEAN TERRITORY',1),

(32, 'BN', 'BRUNEI DARUSSALAM', 1),

(33, 'BG', 'BULGARIA', 1),

(34, 'BF', 'BURKINA FASO', 1),

(35, 'BI', 'BURUNDI', 1),

(36, 'KH', 'CAMBODIA', 1),

(37, 'CM', 'CAMEROON', 1),

(38, 'CA', 'CANADA',1),

(39, 'CV', 'CAPE VERDE', 1),

(40, 'KY', 'CAYMAN ISLANDS', 1),

(41, 'CF', 'CENTRAL AFRICAN REPUBLIC', 1),

(42, 'TD', 'CHAD',1),

(43, 'CL', 'CHILE', 1),

(44, 'CN', 'CHINA', 1),

(45, 'CX', 'CHRISTMAS ISLAND',1),

(46, 'CC', 'COCOS (KEELING) ISLANDS', 1),

(47, 'CO', 'COLOMBIA', 1),

(48, 'KM', 'COMOROS', 1),

(49, 'CG', 'CONGO', 1),

(50, 'CD', 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 1),

(51, 'CK', 'COOK ISLANDS',1),

(52, 'CR', 'COSTA RICA', 1),

(53, 'CI', 'COTE D''IVOIRE', 1),

(54, 'HR', 'CROATIA', 1),

(55, 'CU', 'CUBA',1),

(56, 'CY', 'CYPRUS', 1),

(57, 'CZ', 'CZECH REPUBLIC', 1),

(58, 'DK', 'DENMARK', 1),

(59, 'DJ', 'DJIBOUTI', 1),

(60, 'DM', 'DOMINICA', 1),

(61, 'DO', 'DOMINICAN REPUBLIC', 1),

(62, 'EC', 'ECUADOR', 1),

(63, 'EG', 'EGYPT',1),

(64, 'SV', 'EL SALVADOR', 1),

(65, 'GQ', 'EQUATORIAL GUINEA', 1),

(66, 'ER', 'ERITREA', 1),

(67, 'EE', 'ESTONIA',1),

(68, 'ET', 'ETHIOPIA', 1),

(69, 'FK', 'FALKLAND ISLANDS (MALVINAS)', 1),

(70, 'FO', 'FAROE ISLANDS', 1),

(71, 'FJ', 'FIJI', 1),

(72, 'FI', 'FINLAND', 1),

(73, 'FR', 'FRANCE', 1),

(74, 'GF', 'FRENCH GUIANA', 1),

(75, 'PF', 'FRENCH POLYNESIA', 1),

(76, 'TF', 'FRENCH SOUTHERN TERRITORIES', 1),

(77, 'GA', 'GABON', 1),

(78, 'GM', 'GAMBIA', 1),

(79, 'GE', 'GEORGIA', 1),

(80, 'DE', 'GERMANY', 1),

(81, 'GH', 'GHANA', 1),

(82, 'GI', 'GIBRALTAR', 1),

(83, 'GR', 'GREECE', 1),

(84, 'GL', 'GREENLAND', 1),

(85, 'GD', 'GRENADA', 1),

(86, 'GP', 'GUADELOUPE', 1),

(87, 'GU', 'GUAM', 1),

(88, 'GT', 'GUATEMALA', 1),

(89, 'GN', 'GUINEA', 1),

(90, 'GW', 'GUINEA-BISSAU', 1),

(91, 'GY', 'GUYANA', 1),

(92, 'HT', 'HAITI',1),

(93, 'HM', 'HEARD ISLAND AND MCDONALD ISLANDS', 1),

(94, 'VA', 'HOLY SEE (VATICAN CITY STATE)', 1),

(95, 'HN', 'HONDURAS', 1),

(96, 'HK', 'HONG KONG', 1),

(97, 'HU', 'HUNGARY', 1),

(98, 'IS', 'ICELAND', 1),

(99, 'IN', 'INDIA', 1),

(100, 'ID', 'INDONESIA', 1),

(101, 'IR', 'IRAN, ISLAMIC REPUBLIC OF', 1),

(102, 'IQ', 'IRAQ', 1),

(103, 'IE', 'IRELAND', 1),

(104, 'IL', 'ISRAEL', 1),

(105, 'IT', 'ITALY', 1),

(106, 'JM', 'JAMAICA', 1),

(107, 'JP', 'JAPAN', 1),

(108, 'JO', 'JORDAN', 1),

(109, 'KZ', 'KAZAKHSTAN', 1),

(110, 'KE', 'KENYA', 1),

(111, 'KI', 'KIRIBATI', 1),

(112, 'KP', 'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF', 1),

(113, 'KR', 'KOREA, REPUBLIC OF', 1),

(114, 'KW', 'KUWAIT',1),

(115, 'KG', 'KYRGYZSTAN', 1),

(116, 'LA', 'LAO PEOPLE''S DEMOCRATIC REPUBLIC', 1),

(117, 'LV', 'LATVIA', 1),

(118, 'LB', 'LEBANON', 1),

(119, 'LS', 'LESOTHO', 1),

(120, 'LR', 'LIBERIA', 1),

(121, 'LY', 'LIBYAN ARAB JAMAHIRIYA', 1),

(122, 'LI', 'LIECHTENSTEIN', 1),

(123, 'LT', 'LITHUANIA', 1),

(124, 'LU', 'LUXEMBOURG',1),

(125, 'MO', 'MACAO',1),

(126, 'MK', 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', 1),

(127, 'MG', 'MADAGASCAR', 1),

(128, 'MW', 'MALAWI', 1),

(129, 'MY', 'MALAYSIA', 1),

(130, 'MV', 'MALDIVES', 1),

(131, 'ML', 'MALI',1),

(132, 'MT', 'MALTA', 1),

(133, 'MH', 'MARSHALL ISLANDS', 1),

(134, 'MQ', 'MARTINIQUE', 1),

(135, 'MR', 'MAURITANIA', 1),

(136, 'MU', 'MAURITIUS', 1),

(137, 'YT', 'MAYOTTE',1),

(138, 'MX', 'MEXICO', 1),

(139, 'FM', 'MICRONESIA, FEDERATED STATES OF', 1),

(140, 'MD', 'MOLDOVA, REPUBLIC OF', 1),

(141, 'MC', 'MONACO', 1),

(142, 'MN', 'MONGOLIA', 1),

(143, 'MS', 'MONTSERRAT', 1),

(144, 'MA', 'MOROCCO', 1),

(145, 'MZ', 'MOZAMBIQUE', 1),

(146, 'MM', 'MYANMAR', 1),

(147, 'NA', 'NAMIBIA', 1),

(148, 'NR', 'NAURU', 1),

(149, 'NP', 'NEPAL', 1),

(150, 'NL', 'NETHERLANDS', 1),

(151, 'AN', 'NETHERLANDS ANTILLES', 1),

(152, 'NC', 'NEW CALEDONIA', 1),

(153, 'NZ', 'NEW ZEALAND', 1),

(154, 'NI', 'NICARAGUA', 1),

(155, 'NE', 'NIGER', 1),

(156, 'NG', 'NIGERIA', 1),

(157, 'NU', 'NIUE', 1),

(158, 'NF', 'NORFOLK ISLAND', 1),

(159, 'MP', 'NORTHERN MARIANA ISLANDS',1),

(160, 'NO', 'NORWAY', 1),

(161, 'OM', 'OMAN', 1),

(162, 'PK', 'PAKISTAN',1),

(163, 'PW', 'PALAU',1),

(164, 'PS', 'PALESTINIAN TERRITORY, OCCUPIED', 1),

(165, 'PA', 'PANAMA',  1),

(166, 'PG', 'PAPUA NEW GUINEA',1),

(167, 'PY', 'PARAGUAY', 1),

(168, 'PE', 'PERU',1),

(169, 'PH', 'PHILIPPINES',1),

(170, 'PN', 'PITCAIRN', 1),

(171, 'PL', 'POLAND', 1),

(172, 'PT', 'PORTUGAL',1),

(173, 'PR', 'PUERTO RICO',1),

(174, 'QA', 'QATAR', 1),

(175, 'RE', 'REUNION',1),

(176, 'RO', 'ROMANIA', 1),

(177, 'RU', 'RUSSIAN FEDERATION',1),

(178, 'RW', 'RWANDA', 1),

(179, 'SH', 'SAINT HELENA',1),

(180, 'KN', 'SAINT KITTS AND NEVIS', 1),

(181, 'LC', 'SAINT LUCIA', 1),

(182, 'PM', 'SAINT PIERRE AND MIQUELON', 1),

(183, 'VC', 'SAINT VINCENT AND THE GRENADINES', 1),

(184, 'WS', 'SAMOA',1),

(185, 'SM', 'SAN MARINO', 1),

(186, 'ST', 'SAO TOME AND PRINCIPE', 1),

(187, 'SA', 'SAUDI ARABIA', 1),

(188, 'SN', 'SENEGAL', 1),

(189, 'CS', 'SERBIA AND MONTENEGRO', 1),

(190, 'SC', 'SEYCHELLES', 1),

(191, 'SL', 'SIERRA LEONE', 1),

(192, 'SG', 'SINGAPORE', 1),

(193, 'SK', 'SLOVAKIA', 1),

(194, 'SI', 'SLOVENIA',1),

(195, 'SB', 'SOLOMON ISLANDS', 1),

(196, 'SO', 'SOMALIA', 1),

(197, 'ZA', 'SOUTH AFRICA', 1),

(198, 'GS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 1),

(199, 'ES', 'SPAIN',1),

(200, 'LK', 'SRI LANKA', 1),

(201, 'SD', 'SUDAN',1),

(202, 'SR', 'SURINAME', 1),

(203, 'SJ', 'SVALBARD AND JAN MAYEN', 1),

(204, 'SZ', 'SWAZILAND',1),

(205, 'SE', 'SWEDEN', 1),

(206, 'CH', 'SWITZERLAND', 1),

(207, 'SY', 'SYRIAN ARAB REPUBLIC', 1),

(208, 'TW', 'TAIWAN, PROVINCE OF CHINA',1),

(209, 'TJ', 'TAJIKISTAN', 1),

(210, 'TZ', 'TANZANIA, UNITED REPUBLIC OF', 1),

(211, 'TH', 'THAILAND', 1),

(212, 'TL', 'TIMOR-LESTE', 1),

(213, 'TG', 'TOGO', 1),

(214, 'TK', 'TOKELAU', 1),

(215, 'TO', 'TONGA',1),

(216, 'TT', 'TRINIDAD AND TOBAGO', 1),

(217, 'TN', 'TUNISIA', 1),

(218, 'TR', 'TURKEY', 1),

(219, 'TM', 'TURKMENISTAN', 1),

(220, 'TC', 'TURKS AND CAICOS ISLANDS', 1),

(221, 'TV', 'TUVALU', 1),

(222, 'UG', 'UGANDA', 1),

(223, 'UA', 'UKRAINE', 1),

(224, 'AE', 'UNITED ARAB EMIRATES',1),

(225, 'GB', 'UNITED KINGDOM', 1),

(226, 'US', 'UNITED STATES',1),

(227, 'UM', 'UNITED STATES MINOR OUTLYING ISLANDS', 1),

(228, 'UY', 'URUGUAY',1),

(229, 'UZ', 'UZBEKISTAN', 1),

(230, 'VU', 'VANUATU',1),

(231, 'VE', 'VENEZUELA', 1),

(232, 'VN', 'VIET NAM', 1),

(233, 'VG', 'VIRGIN ISLANDS, BRITISH',1),

(234, 'VI', 'VIRGIN ISLANDS, U.S.', 1),

(235, 'WF', 'WALLIS AND FUTUNA',1),

(236, 'EH', 'WESTERN SAHARA', 1),

(237, 'YE', 'YEMEN', 1),

(238, 'ZM', 'ZAMBIA', 1),

(239, 'ZW', 'ZIMBABWE', 1);


