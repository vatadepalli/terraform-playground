locals {
  first_part  = "hello"
  second_part = "${local.first_part}-there"
  bucket_name = "${local.second_part}-how-are-you-today"
  rendered    = templatefile("./example.tpl", { name = "kevin", number = 7 })
}