require 'rails_helper'

feature "Managing Services", js: true do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:service) { FactoryBot.create(:service, organization: admin.organization) }
  let!(:user_service) { FactoryBot.create(:user_service, user: admin, service: service) }

  let(:webmaster) { FactoryBot.create(:user) }
  let(:webmasters_service) { FactoryBot.create(:service, organization: webmaster.organization) }
  let!(:user_service2) { FactoryBot.create(:user_service, user: webmaster, service: webmasters_service) }

  context "as Admin" do
    before "user creates a Touchpoint" do
      login_as admin
      visit admin_services_path
    end

    it "display Admin-specific UI content" do
      expect(page).to have_content("Organization")
    end
  end

  context "as Webmaster" do
    before "Sign in" do
      login_as webmaster
      visit admin_services_path
    end

    it "display only the Services that belong to Webmaster" do
      expect(page).to have_content("Services")
      expect(page).to have_link("New Service")
      expect(page).to have_content(webmasters_service.name)
      expect(page).to_not have_content(service.name)
      expect(page.current_path).to eq("/admin/services")
    end

    context "logged in as Webmaster, at /admin/services" do
      before "click New Service button" do
        click_link "New Service"
      end

      it "arrive at /admin/services/new" do
        expect(page).to have_content("New Service")
        expect(page).to have_content("Additional Service Managers can be assigned after creating this Service.")
        expect(page).to have_button("Create Service")
        expect(page.current_path).to eq("/admin/services/new")
      end

      describe "#new" do
        describe "unsuccessfully create Service" do
          before do
            @service = FactoryBot.build(:service)
            # fill_in "service_name", with: @service.name
            fill_in "service_description", with: @service.description
            click_button "Create Service"
          end

          it "display error alert message" do
            expect(page).to have_content("1 error prohibited this service from being saved:")
            expect(page).to have_content("Name can't be blank")
            expect(page).to have_content("New Service")
            expect(page).to have_content(@service.description)
          end
        end

        describe "successfully create a Service" do
          before do
            @service = FactoryBot.build(:service)
            fill_in "service_name", with: @service.name
            fill_in "service_description", with: @service.description
            click_button "Create Service"
          end

          it "create Service successfully" do
            expect(page).to have_content("Service was successfully created.")
            expect(page).to have_content(@service.name)
            expect(page).to have_content(@service.description)
          end
        end
      end
    end

    describe "Managing Users for a Service" do
      describe "add Service Manager to Service" do
        before "select User, click Add User" do
          visit admin_service_path(webmasters_service)
          select(admin.email, from: "add-user-dropdown")
          click_on "Add User"
        end

        it "successfully add Admin as a Service Manager" do
          expect(page).to have_content("User successfully added")
          expect(page).to have_content(webmaster.email)
          expect(page).to have_content(admin.email)
          expect(page).to have_content("All Users have been added. No more Service Managers to add.")
        end
      end

      describe "remove Service Manager from Service" do
        before "for a listed User, click Remove" do
          FactoryBot.create(:user_service, user: admin, service: webmasters_service)
          visit admin_service_path(webmasters_service)
          within("table") do
            click_link("Remove")
          end
        end

        it "successfully remove User as a Service Manager" do
          expect(page).to have_content("User successfully removed")
          within("table") do
            expect(page).to have_content(webmaster.email)
            expect(page).to_not have_content(admin.email)
          end
          expect(page).to have_content("Add a User?")
          expect(page).to have_css("#add-user-button[disabled]")
        end
      end
    end
  end

end
