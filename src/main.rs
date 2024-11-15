use axum::{routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(|| async { "Hello world!" }));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();

    let port = listener.local_addr().expect("cannot open port").port();
    println!("Listening on :{}", port);
    axum::serve(listener, app).await.unwrap();
}
