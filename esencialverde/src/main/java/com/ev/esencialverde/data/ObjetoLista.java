/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.data;

/**
 *
 * @author Daniel Granados <dagranados@estudiantec.cr>
 */
public class ObjetoLista {
      private Producto productoObjeto;
      private int cantidad;
      private Precio precioObjeto;
      public ObjetoLista (Producto pProducto, int pCantidad, Precio pPrecio) {
            productoObjeto = pProducto;
            cantidad = pCantidad;
            precioObjeto = pPrecio;
      }

      public Producto getProductoObjeto() {
            return productoObjeto;
      }

      public int getCantidad() {
            return cantidad;
      }

      public Precio getPrecioObjeto() {
            return precioObjeto;
      }
      
      public void modifyCantidad(int pCantidad) {
            cantidad += pCantidad; 
      } 
}
