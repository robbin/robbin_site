FactoryGirl.define do
  sequence(:email) {|n| "person-#{n}@example.com" }
  sequence(:count)

  factory :user do
    name "Regular Doe"

    trait(:male)   { gender "Male" }
    trait(:female) { gender "Female" }
    trait(:admin)  { admin  true }
  end

  factory :article do
    sequence(:title) {|n| "Title #{n}" }
    comments_allowed false
    styles           "styles here"

    factory :unpublished_article do
      published false
    end

    factory :article_with_comments do
      ignore do
        comments_count 3
      end

      after(:create) do |article, evaluator|
        FactoryGirl.create_list(:comment, evaluator.comments_count, :article => article)
      end
    end
  end

  factory :page do
    sequence(:title) {|n| "Page #{n}" }
    body             { Forgery::LoremIpsum.paragraphs(5) }
    styles           "styles here"
  end

  factory :comment do
    article
    email
    body { Forgery::LoremIpsum.sentence }
    full_name "Commenter Bob"
  end
end