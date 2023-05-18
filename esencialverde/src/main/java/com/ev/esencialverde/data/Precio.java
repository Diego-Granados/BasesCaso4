/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.data;

import java.util.ArrayList;


/**
 *
 * @author dandi
 */
public class Precio implements Comparable<Precio>{
      private ArrayList<Lote> cantidadPorLotes;
      private int cantidadTotal;
      private float precioProd;
      private Producto productoPrecio;
      
      public Precio(float pPrecioProd, Producto pProducto, Lote pLote,int pCantidad) {
            cantidadPorLotes = new ArrayList<>();
            cantidadTotal = 0;
            precioProd = pPrecioProd;
            productoPrecio = pProducto;
            insertCantidadLote(pLote, pCantidad);
      }

      public ArrayList<Lote> getCantidadPorLotes() {
            return cantidadPorLotes;
      }

      public void setCantidadPorLotes(ArrayList<Lote> cantidadPorLotes) {
            this.cantidadPorLotes = cantidadPorLotes;
      }
      
      public void insertCantidadLote(Lote pLote, int pCantidad){
            cantidadPorLotes.add(pLote); 
            cantidadTotal += pCantidad;
      }

      public int getCantidadTotal() {
            return cantidadTotal;
      }
      
      @Override public int compareTo(Precio pPrecio) {
        // if the string are not equal
        if (this.precioProd  == pPrecio.precioProd) {
            return 0;
        } else if (this.precioProd  > pPrecio.precioProd) {
              return 1;
        }  else {
            return -1;
        }
    }

      public float getPrecioProd() {
            return precioProd;
      }

      public void setCantidadTotal(int cantidadTotal) {
            this.cantidadTotal = cantidadTotal;
      }

      public void setPrecioProd(float precioProd) {
            this.precioProd = precioProd;
      }
      
      public void modifyCantidad(int pCantidad) {
            cantidadTotal += pCantidad; 
      }     
      
      
}
