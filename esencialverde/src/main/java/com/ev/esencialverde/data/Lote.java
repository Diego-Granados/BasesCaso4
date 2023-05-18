/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.data;

/**
 *
 * @author dandi
 */
public class Lote {
      private int id;
      private String fecha;
      private String productoNombre;
      private int prodContratoId;
      private int plantaId;
      private int cantidad;
      private float costoProduccion;
      private float precio;

      public Lote(int id, String fecha, String productoNombre, int prodContratoId, int plantaId, int cantidad, float costoProduccion, float precio) {
            this.id = id;
            this.fecha = fecha;
            this.productoNombre = productoNombre;
            this.prodContratoId = prodContratoId;
            this.plantaId = plantaId;
            this.cantidad = cantidad;
            this.costoProduccion = costoProduccion;
            this.precio = precio;
      }

      public int getId() {
            return id;
      }

      public String getFecha() {
            return fecha;
      }

      public String getProductoNombre() {
            return productoNombre;
      }

      public int getProdContratoId() {
            return prodContratoId;
      }

      public int getPlantaId() {
            return plantaId;
      }

      public int getCantidad() {
            return cantidad;
      }

      public float getCostoProduccion() {
            return costoProduccion;
      }

      public float getPrecio() {
            return precio;
      }
      public void modifyCantidad(int pCantidad) {
            cantidad += pCantidad; 
      } 
}
