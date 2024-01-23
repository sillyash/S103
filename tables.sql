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
	NumActivité INTEGER NOT NULL,
	NomActivité VARCHAR(50),
	TypeActivité VARCHAR(50),
	PRIMARY KEY(NumActivité)
);

CREATE TABLE ACTICAMPING (
	NumCamping INTEGER NOT NULL,
	NumActivité INTEGER NOT NULL,
	PrixActivité FLOAT,
	PRIMARY KEY(NumCamping,NumActivité),
	FOREIGN KEY(NumCamping) REFERENCES CAMPING(NumCamping),
	FOREIGN KEY(NumActivité) REFERENCES ACTIVITE(NumActivité)
);
