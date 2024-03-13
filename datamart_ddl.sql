CREATE TABLE analysis.dm_rfm_segments (
	user_id int4 NOT NULL PRIMARY KEY,
	recency int4 NOT NULL,
	frequency int4 NOT NULL,
	monetory_value int4 NOT NULL
	CONSTRAINT recency_check CHECK(recency <=(5)::numeric)
	CONSTRAINT frequency_check CHECK(frequency <=(5)::numeric)
	CONSTRAINT monetory_value_check CHECK(monetory_value <=(5)::numeric)
);  