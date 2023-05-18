/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.gui;

import java.math.BigDecimal;
import javax.swing.InputVerifier;
import javax.swing.JComponent;
import javax.swing.JTextField;

/**
 *
 * @author dandi
 */
public class CantidadInputVerifier extends InputVerifier{
      @Override
      public boolean verify (JComponent input) {
            String text = ((JTextField) input).getText();
        try {
            Integer value = new Integer(text);
            value = value / 1;
            return true; 
        } catch (NumberFormatException e) {
            return false;
        }

      }
}