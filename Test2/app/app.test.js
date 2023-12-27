const request = require("supertest");

describe("GET /", () => {
  it("should return 200 OK", async () => {
    const res = await request("http://localhost:3000").get("/");
    expect(res.status).toEqual(200);
  });
});
