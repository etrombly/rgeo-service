#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
use rocket_contrib::json::Json;
use rgeo::search as geo_search;
use rgeo::record::Record;

#[get("/<lat>/<long>")]
fn search(lat: f32, long: f32) -> Json<Option<&'static Record>> {
    let result = geo_search(lat, long);
    match result {
        Some(x) => Json(Some(x.1)),
        _ => Json(None),
    }
}

fn main() {
    rocket::ignite().mount("/", routes![search]).launch();
}