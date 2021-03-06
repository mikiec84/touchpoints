# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Cleanup GTM
service = GoogleApi.new
puts "Cleaning Account Containers for Google Tag Manager Account #{ENV.fetch("GOOGLE_TAG_MANAGER_ACCOUNT_ID")}"
service.clean_account_containers(account_id: ENV.fetch("GOOGLE_TAG_MANAGER_ACCOUNT_ID"))

org = Organization.create!({
  name: "Example.gov",
  domain: "example.gov",
  url: "https://example.gov"
})
puts "Created Default Organization: #{org.name}"

# Create Seeds
admin_user = User.new({
  organization: org,
  email: "admin@example.gov",
  password: "password",
  admin: true
})
admin_user.skip_confirmation!
admin_user.save!
puts "Created Admin User: #{admin_user.email}"


org_1 = Organization.create!({
  name: "Digital.gov",
  domain: "digital.gov",
  url: "https://digital.gov"
})
puts "Creating additional Organization: #{org_1.name}"

program_1 = Program.create!({
  name: "Program 1 for Digital.gov",
  organization: org_1,
  url: "https://digital.gov/program-name"
})
program_2 = Program.create!({
  name: "Program 2 for Digital.gov",
  organization: org_1,
  url: "https://digital.gov/program-name-2"
})

org_2 = Organization.create!({
  name: "Farmers.gov",
  domain: "example.gov",
  url: "https://farmers.gov"
})
program_3 = Program.create!({
  name: "Program 3 for Farmers.gov",
  organization: org_2,
  url: "https://farmers.gov/program-name-3"
})

org_3 = Organization.create!({
  name: "Cloud.gov",
  domain: "cloud.gov",
  url: "https://cloud.gov"
})

webmaster = User.new({
  email: "webmaster@example.gov",
  password: "password",
  organization: org_1
})
webmaster.skip_confirmation!
webmaster.save!
puts "Created #{webmaster.email}"

service_manager = User.new({
  email: "service@example.gov",
  password: "password",
  organization: org_1
})
service_manager.skip_confirmation!
service_manager.save!
puts "Created #{service_manager.email}"

# Forms
form_1 = Form.create({
  name: "Open-ended",
  kind:  "open-ended",
  title: "Custom Open-ended Title",
  instructions: "Share feedback about the new example.gov website and recommend additional features.",
  disclaimer_text: "Disclaimer Text Goes Here",
  notes: ""
})

form_2 = Form.create({
  name: "Recruiter",
  kind:  "recruiter",
  title: "",
  instructions: "",
  disclaimer_text: "Disclaimer Text Goes Here",
  notes: ""
})

form_3 = Form.create({
  name: "À11 - 7 Question Form",
  kind:  "a11",
  title: "",
  instructions: "",
  disclaimer_text: "Disclaimer Text Goes Here",
  notes: ""
})

form_4 = Form.create({
  name: "Open Ended Form with Contact Information",
  kind:  "open-ended-with-contact-info",
  title: "",
  instructions: "",
  disclaimer_text: "Disclaimer Text Goes Here",
  notes: ""
})

service_1  = Service.create!({
  organization: org_1,
  name: "Test Service 1"
})
service_2  = Service.create!({
  organization: org_1,
  name: "Test Service 2"
})
service_3  = Service.create!({
  organization: org_1,
  name: "Test Service 3"
})
service_4  = Service.create!({
  organization: org_2,
  name: "Test Service 4 (for Farmers.gov)"
})

container_1 = Container.create!({
  service_id: service_1.id,
  name: "#{org_1.name}'s Test Container 1"
})

container_2 = Container.create!({
  service_id: service_2.id,
  name: "#{org_1.name}'s Test Container 2"
})

container_3 = Container.create!({
  service_id: service_3.id,
  name: "#{org_2.name}'s Test Container 1"
})

container_4 = Container.create!({
  service_id: service_4.id,
  name: "#{org_2.name}'s Test Container 2"
})

# Touchpoints
touchpoint_1 = Touchpoint.create!({
  form: form_1,
  service: service_1,
  name: "Open-ended Feedback",
  purpose: "Soliciting feedback",
  meaningful_response_size: 30,
  behavior_change: "Looking for opportunities to improve",
  notification_emails: "ryan.wold@gsa.gov"
})

touchpoint_2 = Touchpoint.create!({
  form: form_2,
  service: service_1,
  name: "Recruiter",
  purpose: "Improving Customer Experience with proactive research and service",
  meaningful_response_size: 100,
  behavior_change: "We will use the this feedback to inform Product and Program decisions",
  notification_emails: "ryan.wold@gsa.gov"
})

touchpoint_3 = Touchpoint.create!({
  form: form_3,
  service: service_2,
  name: "A11 - 7 question test - DB",
  purpose: "CX",
  meaningful_response_size: 100,
  behavior_change: "Better customer service",
  notification_emails: "ryan.wold@gsa.gov"
})

Submission.create!({
  touchpoint: touchpoint_1,
  body: "Body text"
})

Submission.create!({
  touchpoint: touchpoint_1,
  body: "Another body text"
})

Submission.create!({
  touchpoint: touchpoint_2,
  first_name: "Mary",
  last_name: "Public",
  email: "public_user_3@example.com",
  phone_number: "5555550000"
})

# TODO: Seed A11
# Submission.create!({
#   touchpoint: touchpoint_3
# })
