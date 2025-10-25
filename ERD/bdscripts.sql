Table users {
user_id uuid [pk, unique]
first_name varchar [not null]
last_name varchar [not null]
email varchar [not null, unique]
password_hash varchar [not null]
phone_number varchar
role enum('guest','host','admin') [not null]
created_at timestamp [default: "CURRENT_TIMESTAMP"]
}

Table properties {
property_id uuid [pk, unique]
host_id uuid [not null, ref: > users.user_id]
name varchar [not null]
description text [not null]
location varchar [not null]
pricepernight decimal [not null]
created_at timestamp [default: "CURRENT_TIMESTAMP"]
updated_at timestamp
}

Table bookings {
booking_id uuid [pk, unique]
property_id uuid [not null, ref: > properties.property_id]
user_id uuid [not null, ref: > users.user_id]
start_date date [not null]
end_date date [not null]
total_price decimal [not null]
status enum('pending','confirmed','canceled') [not null]
created_at timestamp [default: "CURRENT_TIMESTAMP"]
}

Table payments {
payment_id uuid [pk, unique]
booking_id uuid [not null, ref: > bookings.booking_id]
amount decimal [not null]
payment_date timestamp [default: "CURRENT_TIMESTAMP"]
payment_method enum('credit_card','paypal','stripe') [not null]
}

Table reviews {
review_id uuid [pk, unique]
property_id uuid [not null, ref: > properties.property_id]
user_id uuid [not null, ref: > users.user_id]
rating int [not null, note: "1-5"]
comment text [not null]
created_at timestamp [default: "CURRENT_TIMESTAMP"]
}

Table messages {
message_id uuid [pk, unique]
sender_id uuid [not null, ref: > users.user_id]
recipient_id uuid [not null, ref: > users.user_id]
message_body text [not null]
sent_at timestamp [default: "CURRENT_TIMESTAMP"]
}