/* Quartus Prime Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEBA6) Path("D:/Users/James/NextCloud/Quartus/LC3/") File("LC3.jic") MfrSpec(OpMask(1) SEC_Device(EPCS64) Child_OpMask(1 1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
