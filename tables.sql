CREATE TABLE CAMPING (
	NumCamping INTEGER NOT NULL,
	NomCamping VARCHAR(50),
	QualitéFrance VARCHAR(50) NOT NULL,
 	NbEtoiles INT NOT NULL,
	AddrCamping VARCHAR(50),
 	TelCamping VARCHAR(15),
	DateOuv DATE,
	DateFerm DATE,
	PRIMARY KEY(NumCamping)
);

CREATE TABLE ACTIVITE (
	NumActivite INTEGER NOT NULL,
	NomActivite VARCHAR(50),
	TypeActivite VARCHAR(50),
	PRIMARY KEY(NumActivite)
);

CREATE TABLE ACTICAMPING (
	NumCamping INTEGER NOT NULL,
	NumActivite INTEGER NOT NULL,
	PrixActivite FLOAT,
	PRIMARY KEY(NumCamping,NumActivite),
	FOREIGN KEY(NumCamping) REFERENCES CAMPING(NumCamping),
	FOREIGN KEY(NumActivite) REFERENCES ACTIVITE(NumActivite)
);
