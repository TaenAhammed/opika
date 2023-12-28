const request = require("supertest");
const server = require("./app");

describe("GET /", () => {
  it("should return 200 OK", async () => {
    const res = await request(server)
      .get("/")
      .expect("Content-Type", /json/)
      .expect(200);

    expect(res.body).toHaveProperty("message");
  });
});
