CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "addresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "address" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "latitude" float, "longitude" float);
CREATE TABLE "service_requests" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Address_id" integer, "unique_key" varchar, "complaint_type" varchar, "descriptor" varchar, "created_date" datetime, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_service_requests_on_Address_id" ON "service_requests" ("Address_id");
INSERT INTO schema_migrations (version) VALUES ('20160402044039');

INSERT INTO schema_migrations (version) VALUES ('20160407174606');

INSERT INTO schema_migrations (version) VALUES ('20160407191316');

