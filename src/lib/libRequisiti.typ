// Modulo opzionale per il tracciamento dei requisiti di progetto (Akme Group)

#let get-req-by-id = (lista, id) => {
  if lista != none {
    lista.find(item => item.id == id)
  } else {
    none
  }
}

