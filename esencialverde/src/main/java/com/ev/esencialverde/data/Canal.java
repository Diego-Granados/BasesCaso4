/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.data;

/**
 *
 * @author Daniel Granados <dagranados@estudiantec.cr>
 */
public class Canal {
      private String nombre;
      private int id;
      public Canal(int pId, String pNombre) {
            id = pId;
            nombre = pNombre;
      }

      public String getNombre() {
            return nombre;
      }

      public int getId() {
            return id;
      }
      
}
