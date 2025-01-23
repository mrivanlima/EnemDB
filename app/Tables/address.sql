create table app.address
(
    address_id serial,
    city varchar(100) not null,
    state varchar(100) not null,
    street varchar(100) not null,
    number varchar(100) not null,
    complement varchar(100) not null,
    neighborhood varchar(100) not null,
    zipCode varchar(100) not null,
    --created_by integer null,
    created_on timestamp with time zone default current_timestamp,
    --modified_by integer null,
    modified_on timestamp with time zone default current_timestamp,
    constraint pk_address primary key (address_id)
    --constraint fk_address_created_by foreign key (created_by) references app.account(user_id),
    --constraint fk_address_modified_by foreign key (modified_by) references app.account(user_id)
);