require "spec_helper"

describe "envhook" do

  let(:path) { "/_envhook/config" }

  context "with incorrect auth" do
    before { authorize(username, "wrong") }
    it "responds 401" do
      post(path)
      expect(response.status).to eq(401)
    end
  end

  context "with valid authentication" do
    before { authorize(username, password) }
    it "responds 200 OK" do
      post_json(path, {"TEST_CONFIG" => "updated"})
      expect(response.status).to eq(200)
    end

    it "responds 404 for an incorrect path" do
      envhook_auth
      post(path + "/wrong")
      expect(response.status).to eq(404)
    end
  end

end
