/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.data;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

/**
 *
 * @author dandi
 */
public class Producto {
      private int id;
      private String nombre;
      private HashMap<Float, Precio> precios;
      private ArrayList<Float> preciosOrder;
      
      public Producto(int pId, String pNombre){
            id = pId;
            nombre = pNombre;
            precios = new HashMap<>();
            preciosOrder = new ArrayList<>();
      }

      public int getId() {
            return id;
      }

      public String getNombre() {
            return nombre;
      }

      public HashMap<Float, Precio> getPrecios() {
            return precios;
      }

      public void setId(int id) {
            this.id = id;
      }

      public void setNombre(String nombre) {
            this.nombre = nombre;
      }

      public void setPrecios(HashMap<Float, Precio> precios) {
            this.precios = precios;
      }
      
      
      public void insertPrecio(Float pPrecio, Lote pLote, int pCantidad){
            precios.put(pPrecio, new Precio(pPrecio, this, pLote, pCantidad));
            preciosOrder.add(pPrecio);
            Collections.sort(preciosOrder);
      }
}
